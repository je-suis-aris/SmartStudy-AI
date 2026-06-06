package com.smartstudy.model;

public class Flashcard {

    private int id;
    private int userId;
    private int courseId;
    private int materialId;

    private String courseTitle;
    private String materialTitle;

    private String frontText;
    private String backText;

    private String generationSource;
    private String generationBatch;

    private String createdAt;

    public Flashcard() {
    }

    public Flashcard(
            int id,
            int userId,
            int courseId,
            int materialId,
            String frontText,
            String backText,
            String createdAt
    ) {
        this.id = id;
        this.userId = userId;
        this.courseId = courseId;
        this.materialId = materialId;
        this.frontText = frontText;
        this.backText = backText;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }


    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }


    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }


    public int getMaterialId() {
        return materialId;
    }

    public void setMaterialId(int materialId) {
        this.materialId = materialId;
    }


    public String getCourseTitle() {
        return courseTitle;
    }

    public void setCourseTitle(String courseTitle) {
        this.courseTitle = courseTitle;
    }


    public String getMaterialTitle() {
        return materialTitle;
    }

    public void setMaterialTitle(String materialTitle) {
        this.materialTitle = materialTitle;
    }


    public String getFrontText() {
        return frontText;
    }

    public void setFrontText(String frontText) {
        this.frontText = frontText;
    }


    public String getBackText() {
        return backText;
    }

    public void setBackText(String backText) {
        this.backText = backText;
    }


    public String getGenerationSource() {
        return generationSource;
    }

    public void setGenerationSource(String generationSource) {
        this.generationSource = generationSource;
    }


    public String getGenerationBatch() {
        return generationBatch;
    }

    public void setGenerationBatch(String generationBatch) {
        this.generationBatch = generationBatch;
    }


    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }
}