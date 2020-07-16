package com.hospital.domain;

import java.sql.Date;
import java.sql.Timestamp;

/**
 * @author liyu
 */
public class Register {
    private int id;
    private int medicalRecord;
    private int gender;
    private String idNumber;
    private Date birthday;
    private int payWay;
    private String address;
    private Date diagDate;
    private String noon;
    private Timestamp regiDate;
    private int depaId;
    private int doctorId;
    private int needRecord;
    private int registrarId;
    private int status;

    @Override
    public String toString() {
        return "Register{" +
                "id=" + id +
                ", medicalRecord=" + medicalRecord +
                ", gender=" + gender +
                ", idNumber='" + idNumber + '\'' +
                ", birthday=" + birthday +
                ", payWay=" + payWay +
                ", address='" + address + '\'' +
                ", diagDate=" + diagDate +
                ", noon='" + noon + '\'' +
                ", regiDate=" + regiDate +
                ", depaId=" + depaId +
                ", doctorId=" + doctorId +
                ", needRecord=" + needRecord +
                ", registrarId=" + registrarId +
                ", status=" + status +
                '}';
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getMedicalRecord() {
        return medicalRecord;
    }

    public void setMedicalRecord(int medicalRecord) {
        this.medicalRecord = medicalRecord;
    }

    public int getGender() {
        return gender;
    }

    public void setGender(int gender) {
        this.gender = gender;
    }

    public String getIdNumber() {
        return idNumber;
    }

    public void setIdNumber(String idNumber) {
        this.idNumber = idNumber;
    }

    public Date getBirthday() {
        return birthday;
    }

    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }

    public int getPayWay() {
        return payWay;
    }

    public void setPayWay(int payWay) {
        this.payWay = payWay;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Date getDiagDate() {
        return diagDate;
    }

    public void setDiagDate(Date diagDate) {
        this.diagDate = diagDate;
    }

    public String getNoon() {
        return noon;
    }

    public void setNoon(String noon) {
        this.noon = noon;
    }

    public Timestamp getRegiDate() {
        return regiDate;
    }

    public void setRegiDate(Timestamp regiDate) {
        this.regiDate = regiDate;
    }

    public int getDepaId() {
        return depaId;
    }

    public void setDepaId(int depaId) {
        this.depaId = depaId;
    }

    public int getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }

    public int getNeedRecord() {
        return needRecord;
    }

    public void setNeedRecord(int needRecord) {
        this.needRecord = needRecord;
    }

    public int getRegistrarId() {
        return registrarId;
    }

    public void setRegistrarId(int registrarId) {
        this.registrarId = registrarId;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
}
