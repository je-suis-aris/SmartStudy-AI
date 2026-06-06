package com.smartstudy.model;

public class DashboardStats {

    private int totalCourses;
    private int totalMaterials;
    private int totalStudyMinutes;

    private double averageScore;

    public int getTotalCourses() {
        return totalCourses;
    }

    public void setTotalCourses(int totalCourses) {
        this.totalCourses = totalCourses;
    }


    public int getTotalMaterials() {
        return totalMaterials;
    }

    public void setTotalMaterials(int totalMaterials) {
        this.totalMaterials = totalMaterials;
    }


    public int getTotalStudyMinutes() {
        return totalStudyMinutes;
    }

    public void setTotalStudyMinutes(int totalStudyMinutes) {
        this.totalStudyMinutes = totalStudyMinutes;
    }


    public double getAverageScore() {
        return averageScore;
    }

    public void setAverageScore(double averageScore) {
        this.averageScore = averageScore;
    }
}