package com.hospital.vo;

import java.sql.Date;
import java.sql.Timestamp;

/**
 * @author liyu
 */
public class VoDiagnose {
    private int recordNum;
    private int registerId;
    private int diagType;
    private int diseaseId;
    private String diseaseName;
    private Timestamp insertTime;
    private Date diagnoseDate;
    private String icd;

    @Override
    public String toString() {
        return "VoDiagnose{" +
                "recordNum=" + recordNum +
                ", registerId=" + registerId +
                ", diagType=" + diagType +
                ", diseaseId=" + diseaseId +
                ", diseaseName='" + diseaseName + '\'' +
                ", insertTime=" + insertTime +
                ", diagnoseDate=" + diagnoseDate +
                ", icd='" + icd + '\'' +
                '}';
    }

    public String getIcd() {
        return icd;
    }

    public void setIcd(String icd) {
        this.icd = icd;
    }

    public int getRecordNum() {
        return recordNum;
    }

    public void setRecordNum(int recordNum) {
        this.recordNum = recordNum;
    }

    public int getRegisterId() {
        return registerId;
    }

    public void setRegisterId(int registerId) {
        this.registerId = registerId;
    }

    public int getDiagType() {
        return diagType;
    }

    public void setDiagType(int diagType) {
        this.diagType = diagType;
    }

    public int getDiseaseId() {
        return diseaseId;
    }

    public void setDiseaseId(int diseaseId) {
        this.diseaseId = diseaseId;
    }

    public String getDiseaseName() {
        return diseaseName;
    }

    public void setDiseaseName(String diseaseName) {
        this.diseaseName = diseaseName;
    }

    public Timestamp getInsertTime() {
        return insertTime;
    }

    public void setInsertTime(Timestamp insertTime) {
        this.insertTime = insertTime;
        if (insertTime != null){
            this.diagnoseDate = new Date(insertTime.getTime());
        }
    }

    public Date getDiagnoseDate() {
        return diagnoseDate;
    }

    public void setDiagnoseDate(Date diagnoseDate) {
        this.diagnoseDate = diagnoseDate;
    }
}
