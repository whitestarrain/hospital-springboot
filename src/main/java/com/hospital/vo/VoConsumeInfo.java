package com.hospital.vo;

import java.sql.Date;

/**
 * @author liyu
 */
public class VoConsumeInfo {
    private int recordNum;
    private String name;
    private String presName;
    private String presPrice;
    private Date presDate;
    private int status;

    @Override
    public String toString() {
        return "VoConsumeInfo{" +
                "recordNum=" + recordNum +
                ", name='" + name + '\'' +
                ", presName='" + presName + '\'' +
                ", presPrice='" + presPrice + '\'' +
                ", presDate=" + presDate +
                ", status=" + status +
                '}';
    }

    public int getRecordNum() {
        return recordNum;
    }

    public void setRecordNum(int recordNum) {
        this.recordNum = recordNum;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPresName() {
        return presName;
    }

    public void setPresName(String presName) {
        this.presName = presName;
    }

    public String getPresPrice() {
        return presPrice;
    }

    public void setPresPrice(String presPrice) {
        this.presPrice = presPrice;
    }

    public Date getPresDate() {
        return presDate;
    }

    public void setPresDate(Date presDate) {
        this.presDate = presDate;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
}
