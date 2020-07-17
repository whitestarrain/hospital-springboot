package com.hospital.domain;

/**
 * @author liyu
 */
public class MedicalRecord {
    private  int recordNum;
    private String symptom;
    private String nowHistory;
    private String anamnesis;
    private String allergyhis;
    private String treatment;
    private String checkup;
    private String checkSugg;
    private String attention;
    private String result;

    @Override
    public String toString() {
        return "MedicalRecord{" +
                "recordNum=" + recordNum +
                ", symptom='" + symptom + '\'' +
                ", nowHistory='" + nowHistory + '\'' +
                ", anamnesis='" + anamnesis + '\'' +
                ", allergyhis='" + allergyhis + '\'' +
                ", treatment='" + treatment + '\'' +
                ", checkup='" + checkup + '\'' +
                ", checkSugg='" + checkSugg + '\'' +
                ", attention='" + attention + '\'' +
                ", result='" + result + '\'' +
                '}';
    }

    public int getRecordNum() {
        return recordNum;
    }

    public void setRecordNum(int recordNum) {
        this.recordNum = recordNum;
    }

    public String getSymptom() {
        return symptom;
    }

    public void setSymptom(String symptom) {
        this.symptom = symptom;
    }

    public String getNowHistory() {
        return nowHistory;
    }

    public void setNowHistory(String nowHistory) {
        this.nowHistory = nowHistory;
    }

    public String getAnamnesis() {
        return anamnesis;
    }

    public void setAnamnesis(String anamnesis) {
        this.anamnesis = anamnesis;
    }

    public String getAllergyhis() {
        return allergyhis;
    }

    public void setAllergyhis(String allergyhis) {
        this.allergyhis = allergyhis;
    }

    public String getTreatment() {
        return treatment;
    }

    public void setTreatment(String treatment) {
        this.treatment = treatment;
    }

    public String getCheckup() {
        return checkup;
    }

    public void setCheckup(String checkup) {
        this.checkup = checkup;
    }

    public String getCheckSugg() {
        return checkSugg;
    }

    public void setCheckSugg(String checkSugg) {
        this.checkSugg = checkSugg;
    }

    public String getAttention() {
        return attention;
    }

    public void setAttention(String attention) {
        this.attention = attention;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }
}
