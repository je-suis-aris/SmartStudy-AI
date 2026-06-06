package com.smartstudy.model;

public class AiFeedback {

    private int id;
    private int userId;
    private Integer courseId;
    private String feedbackType;
    private String feedbackText;
    private String createdAt;

    public AiFeedback() {
    }

    public AiFeedback(int userId, Integer courseId, String feedbackType, String feedbackText) {
        this.userId = userId;
        this.courseId = courseId;
        this.feedbackType = feedbackType;
        this.feedbackText = feedbackText;
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


    public Integer getCourseId() {
        return courseId;
    }

    public void setCourseId(Integer courseId) {
        this.courseId = courseId;
    }


    public String getFeedbackType() {
        return feedbackType;
    }

    public void setFeedbackType(String feedbackType) {
        this.feedbackType = feedbackType;
    }


    public String getFeedbackText() {
        return feedbackText;
    }

    public void setFeedbackText(String feedbackText) {
        this.feedbackText = feedbackText;
    }


    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }
}