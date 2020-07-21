package com.hospital.vo;

import java.sql.Date;

/**
 * @author liyu
 */
public class VoDrugDistribute {
    private String name;
    private String price;
    private int number;
    private int status ;
    private String userName;
    private String presName;
    private Date presDate;

    @Override
    public String toString() {
        return "VoDrugDistribute{" +
                "name='" + name + '\'' +
                ", price='" + price + '\'' +
                ", number=" + number +
                ", status=" + status +
                ", userName='" + userName + '\'' +
                ", presName='" + presName + '\'' +
                ", presDate=" + presDate +
                '}';
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public int getNumber() {
        return number;
    }

    public void setNumber(int number) {
        this.number = number;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPresName() {
        return presName;
    }

    public void setPresName(String presName) {
        this.presName = presName;
    }

    public Date getPresDate() {
        return presDate;
    }

    public void setPresDate(Date presDate) {
        this.presDate = presDate;
    }
}
