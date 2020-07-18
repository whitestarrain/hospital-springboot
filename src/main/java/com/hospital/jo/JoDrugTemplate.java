package com.hospital.jo;

import java.math.BigDecimal;

/**
 * @author liyu
 */
public class JoDrugTemplate {
    private String name;
    private String specification;
    private String useWay;
    private String dosage;
    private String frequency;
    private int number;
    private BigDecimal price;

    @Override
    public String toString() {
        return "JoDrugTemplate{" +
                "name='" + name + '\'' +
                ", specification='" + specification + '\'' +
                ", useWay='" + useWay + '\'' +
                ", dosage='" + dosage + '\'' +
                ", frequency='" + frequency + '\'' +
                ", number=" + number +
                ", price=" + price +
                '}';
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSpecification() {
        return specification;
    }

    public void setSpecification(String specification) {
        this.specification = specification;
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

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }
}
