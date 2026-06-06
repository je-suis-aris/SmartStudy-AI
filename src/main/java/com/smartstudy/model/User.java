package com.smartstudy.model;

public class User {
    private int id;
    private String fullName;
    private String email;
    private String passwordHash;
    private String role;
    private String description;
    private String profilePhoto;
    private String preferredStudyRhythm;
    private String learningStyle;

    private String adminRequestStatus;
    private String adminRequestReason;
    private String adminRequestCreatedAt;
    private String adminRequestReviewedAt;

    public User() {
    }

    public User(int id, String fullName, String email, String passwordHash, String role, String description) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role;
        this.description = description;
    }

    public User(int id, String fullName, String email, String passwordHash, String role, String description, String profilePhoto) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role;
        this.description = description;
        this.profilePhoto = profilePhoto;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }


    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }


    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }


    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }


    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }


    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }


    public String getProfilePhoto() {
        return profilePhoto;
    }

    public void setProfilePhoto(String profilePhoto) {
        this.profilePhoto = profilePhoto;
    }


    public String getPreferredStudyRhythm() {
        return preferredStudyRhythm;
    }

    public void setPreferredStudyRhythm(String preferredStudyRhythm) {
        this.preferredStudyRhythm = preferredStudyRhythm;
    }


    public String getLearningStyle() {
        return learningStyle;
    }

    public void setLearningStyle(String learningStyle) {
        this.learningStyle = learningStyle;
    }


    public String getAdminRequestStatus() {
        return adminRequestStatus;
    }

    public void setAdminRequestStatus(String adminRequestStatus) {
        this.adminRequestStatus = adminRequestStatus;
    }


    public String getAdminRequestReason() {
        return adminRequestReason;
    }

    public void setAdminRequestReason(String adminRequestReason) {
        this.adminRequestReason = adminRequestReason;
    }


    public String getAdminRequestCreatedAt() {
        return adminRequestCreatedAt;
    }

    public void setAdminRequestCreatedAt(String adminRequestCreatedAt) {
        this.adminRequestCreatedAt = adminRequestCreatedAt;
    }


    public String getAdminRequestReviewedAt() {
        return adminRequestReviewedAt;
    }

    public void setAdminRequestReviewedAt(String adminRequestReviewedAt) {
        this.adminRequestReviewedAt = adminRequestReviewedAt;
    }
}