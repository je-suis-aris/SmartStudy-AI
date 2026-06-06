-- =====================================================================
-- SmartStudy AI - schéma additionnel pour le banc d'expérimentation
-- =====================================================================
-- Ce script aligne la base de données sur les colonnes utilisées
-- réellement par les DAO et services (FlashcardDAO, QuizMistakeDAO,
-- PlannerRecommendationService, etc.). Le fichier d'origine
-- `smartstudy_ai.sql` ne couvre qu'un schéma minimal de démonstration.
--
-- À exécuter UNE FOIS après `smartstudy_ai.sql`, avant la première
-- exécution du seeder ou du runner d'expériences :
--    SOURCE database/experiments_schema.sql;
--
-- Le script est idempotent (utilise IF NOT EXISTS / ADD COLUMN IF NOT EXISTS).
-- =====================================================================

USE smartstudy_ai;

-- --------------------------------------------------------------
-- flashcards : colonnes utilisées par FlashcardDAO.create(...)
-- --------------------------------------------------------------
ALTER TABLE flashcards
    ADD COLUMN IF NOT EXISTS material_id INT NULL AFTER course_id,
    ADD COLUMN IF NOT EXISTS generation_source VARCHAR(40) NOT NULL DEFAULT 'AI' AFTER back_text,
    ADD COLUMN IF NOT EXISTS generation_batch VARCHAR(60) NULL AFTER generation_source,
    ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP AFTER generation_batch;

-- --------------------------------------------------------------
-- quiz_mistakes : créée par QuizMistakeDAO
-- --------------------------------------------------------------
CREATE TABLE IF NOT EXISTS quiz_mistakes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    material_id INT NULL,
    question_id INT NULL,
    question_text TEXT NOT NULL,
    selected_answer VARCHAR(255) NULL,
    correct_answer VARCHAR(255) NULL,
    correct_answer_text TEXT NULL,
    explanation TEXT NULL,
    resolved BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_qm_user (user_id),
    INDEX idx_qm_user_resolved (user_id, resolved),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    FOREIGN KEY (material_id) REFERENCES materials(id) ON DELETE SET NULL,
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE SET NULL
);

-- --------------------------------------------------------------
-- study_plan_items : colonnes utilisées par PlannerRecommendationService
-- --------------------------------------------------------------
ALTER TABLE study_plan_items
    ADD COLUMN IF NOT EXISTS description TEXT NULL,
    ADD COLUMN IF NOT EXISTS actual_seconds INT NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS status VARCHAR(20) NOT NULL DEFAULT 'TODO',
    ADD COLUMN IF NOT EXISTS priority VARCHAR(10) NOT NULL DEFAULT 'MEDIUM',
    ADD COLUMN IF NOT EXISTS generated_by VARCHAR(10) NOT NULL DEFAULT 'USER';

-- --------------------------------------------------------------
-- planner_recommendations : créée par PlannerRecommendationService
-- --------------------------------------------------------------
CREATE TABLE IF NOT EXISTS planner_recommendations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(120) NOT NULL,
    body TEXT NOT NULL,
    source VARCHAR(20) NOT NULL DEFAULT 'AI',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_pr_user (user_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- --------------------------------------------------------------
-- Index supplémentaires utilisés par les expériences de latence
-- --------------------------------------------------------------
ALTER TABLE quiz_results       ADD INDEX IF NOT EXISTS idx_qr_user_created (user_id, created_at);
ALTER TABLE quiz_results       ADD INDEX IF NOT EXISTS idx_qr_user_course (user_id, course_id);
ALTER TABLE flashcards         ADD INDEX IF NOT EXISTS idx_fc_user (user_id);
ALTER TABLE flashcards         ADD INDEX IF NOT EXISTS idx_fc_user_material (user_id, material_id);
ALTER TABLE materials          ADD INDEX IF NOT EXISTS idx_mat_user (user_id);
ALTER TABLE materials          ADD INDEX IF NOT EXISTS idx_mat_course (course_id);
ALTER TABLE questions          ADD INDEX IF NOT EXISTS idx_q_course (course_id);
ALTER TABLE study_sessions     ADD INDEX IF NOT EXISTS idx_ss_user (user_id);
