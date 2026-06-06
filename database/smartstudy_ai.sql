DROP DATABASE IF EXISTS smartstudy_ai;
CREATE DATABASE smartstudy_ai CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE smartstudy_ai;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(120) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE,
  password_hash VARCHAR(128) NOT NULL,
  role ENUM('STUDENT','ADMIN') NOT NULL DEFAULT 'STUDENT',
  description TEXT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE courses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NULL,
  title VARCHAR(150) NOT NULL,
  description TEXT NOT NULL,
  exam_date DATE NULL,
  difficulty ENUM('EASY','MEDIUM','HARD') DEFAULT 'MEDIUM',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE disciplines (
  id INT AUTO_INCREMENT PRIMARY KEY,
  course_id INT NOT NULL,
  title VARCHAR(150) NOT NULL,
  description TEXT NOT NULL,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

CREATE TABLE materials (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  course_id INT NOT NULL,
  discipline_id INT NULL,
  title VARCHAR(180) NOT NULL,
  material_type ENUM('PDF_TEXT','DOCX_TEXT','TRANSCRIPT','MANUAL_TEXT') DEFAULT 'MANUAL_TEXT',
  content_text MEDIUMTEXT NOT NULL,
  ai_status ENUM('PENDING','PROCESSED') DEFAULT 'PENDING',
  summary MEDIUMTEXT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  FOREIGN KEY (discipline_id) REFERENCES disciplines(id) ON DELETE SET NULL
);

CREATE TABLE questions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  course_id INT NOT NULL,
  discipline_id INT NULL,
  material_id INT NULL,
  question_text TEXT NOT NULL,
  option_a VARCHAR(255) NOT NULL,
  option_b VARCHAR(255) NOT NULL,
  option_c VARCHAR(255) NOT NULL,
  option_d VARCHAR(255) NOT NULL,
  correct_answer CHAR(1) NOT NULL,
  explanation TEXT NULL,
  generated_by_ai BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  FOREIGN KEY (discipline_id) REFERENCES disciplines(id) ON DELETE SET NULL,
  FOREIGN KEY (material_id) REFERENCES materials(id) ON DELETE SET NULL
);

CREATE TABLE flashcards (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  course_id INT NOT NULL,
  front_text TEXT NOT NULL,
  back_text TEXT NOT NULL,
  next_review DATE NULL,
  box_level INT DEFAULT 1,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

CREATE TABLE quiz_results (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  course_id INT NOT NULL,
  discipline_id INT NULL,
  score INT NOT NULL,
  total_questions INT NOT NULL,
  duration_seconds INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  FOREIGN KEY (discipline_id) REFERENCES disciplines(id) ON DELETE SET NULL
);

CREATE TABLE study_sessions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  course_id INT NOT NULL,
  minutes_spent INT NOT NULL,
  session_date DATE NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

CREATE TABLE study_plan_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  course_id INT NOT NULL,
  plan_date DATE NOT NULL,
  task_title VARCHAR(200) NOT NULL,
  estimated_minutes INT DEFAULT 60,
  completed BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

CREATE TABLE gap_alerts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  course_id INT NOT NULL,
  discipline_id INT NULL,
  message TEXT NOT NULL,
  severity ENUM('LOW','MEDIUM','HIGH') DEFAULT 'MEDIUM',
  solved BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  FOREIGN KEY (discipline_id) REFERENCES disciplines(id) ON DELETE SET NULL
);

INSERT INTO users(full_name,email,password_hash,role,description) VALUES
('Administrator','admin@smartstudy.com','password','ADMIN','Administrator account'),
('Student Demo','student@smartstudy.com','password','STUDENT','Student in Web Programming 2');

INSERT INTO courses(user_id,title,description,exam_date,difficulty) VALUES
(2,'Programmation Web 2','Java EE, JSP, Servlets, JDBC, MVC, Bootstrap et JavaScript.','2026-06-15','MEDIUM'),
(2,'Bases de données','SQL, relations, clés primaires, clés étrangères et requêtes.','2026-06-20','MEDIUM');

INSERT INTO disciplines(course_id,title,description) VALUES
(1,'JSP','Pages dynamiques côté serveur.'),
(1,'Servlets','Contrôleurs Java qui traitent les requêtes HTTP.'),
(1,'JDBC','Connexion et requêtes vers la base de données.'),
(1,'MVC','Séparation entre modèle, vue et contrôleur.'),
(2,'SQL','Langage de manipulation des données.');

INSERT INTO materials(user_id,course_id,discipline_id,title,material_type,content_text,ai_status,summary) VALUES
(2,1,2,'Introduction aux Servlets','MANUAL_TEXT','Une servlet est une classe Java exécutée sur un serveur web. Elle reçoit une requête HTTP, traite les données et renvoie une réponse. Dans une architecture MVC, les servlets jouent le rôle de contrôleur. Elles communiquent avec les DAO pour accéder à la base de données et redirigent vers des pages JSP pour l affichage.','PROCESSED','Les servlets traitent les requêtes HTTP, utilisent les DAO et redirigent vers les JSP.'),
(2,1,3,'JDBC résumé','MANUAL_TEXT','JDBC permet à une application Java de se connecter à une base de données relationnelle. On utilise DriverManager, Connection, PreparedStatement et ResultSet. PreparedStatement réduit les risques d injection SQL.','PROCESSED','JDBC assure la connexion Java-MySQL avec Connection, PreparedStatement et ResultSet.');

INSERT INTO questions(course_id,discipline_id,material_id,question_text,option_a,option_b,option_c,option_d,correct_answer,explanation,generated_by_ai) VALUES
(1,2,1,'Quel est le rôle principal d une servlet dans MVC ?','Afficher le CSS','Contrôler les requêtes HTTP','Créer la base de données','Compiler le navigateur','B','La servlet agit comme contrôleur entre la vue JSP et le modèle DAO.',true),
(1,3,2,'Quel objet JDBC permet d exécuter une requête paramétrée ?','PreparedStatement','Scanner','HttpSession','ArrayList','A','PreparedStatement permet les paramètres et limite les injections SQL.',true);

INSERT INTO flashcards(user_id,course_id,front_text,back_text,next_review,box_level) VALUES
(2,1,'Que signifie MVC ?','Model View Controller',CURRENT_DATE,1),
(2,1,'Rôle de PreparedStatement','Exécuter des requêtes SQL paramétrées',CURRENT_DATE,1);

INSERT INTO quiz_results(user_id,course_id,discipline_id,score,total_questions,duration_seconds) VALUES
(2,1,2,1,2,120),(2,1,3,2,2,90),(2,2,5,1,2,100);

INSERT INTO study_sessions(user_id,course_id,minutes_spent,session_date) VALUES
(2,1,75,CURRENT_DATE),(2,1,40,DATE_SUB(CURRENT_DATE, INTERVAL 1 DAY)),(2,2,55,CURRENT_DATE);

INSERT INTO study_plan_items(user_id,course_id,plan_date,task_title,estimated_minutes,completed) VALUES
(2,1,CURRENT_DATE,'Réviser les Servlets et refaire le quiz',60,false),
(2,1,DATE_ADD(CURRENT_DATE, INTERVAL 1 DAY),'Lire le résumé JDBC et créer des flashcards',45,false);

INSERT INTO gap_alerts(user_id,course_id,discipline_id,message,severity) VALUES
(2,1,2,'Difficulté détectée en Servlets. Voulez-vous refaire le test ?', 'HIGH'),
(2,2,5,'Résultat moyen en SQL. Révision recommandée.', 'MEDIUM');
