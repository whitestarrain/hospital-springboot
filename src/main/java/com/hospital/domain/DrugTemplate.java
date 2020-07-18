package com.hospital.domain;

/**
 * @author liyu
 */
public class DrugTemplate {
    private int presId;
    private int drugId;
    private String useWay;
    private String dosage;
    private String frequency;
    private int number;

    @Override
    public String toString() {
        return "DrugTemplate{" +
                "presId=" + presId +
                ", drugId=" + drugId +
                ", useWay='" + useWay + '\'' +
                ", dosage='" + dosage + '\'' +
                ", frequency='" + frequency + '\'' +
                ", number=" + number +
                '}';
    }

    public int getPresId() {
        return presId;
    }

    public void setPresId(int presId) {
        this.presId = presId;
    }

    public int getDrugId() {
        return drugId;
    }

    public void setDrugId(int drugId) {
        this.drugId = drugId;
    }

    public String getUseWay() {
        return useWay;
    }

    public void setUseWay(String useWay) {
        this.useWay = useWay;
    }

    public String getDosage() {
        return dosage;
    }

    public void setDosage(String dosage) {
        this.dosage = dosage;
    }

    public String getFrequency() {
        return frequency;
    }

    public void setFrequency(String frequency) {
        this.frequency = frequency;
    }

    public int getNumber() {
        return number;
    }

    public void setNumber(int number) {
        this.number = number;
    }
}
