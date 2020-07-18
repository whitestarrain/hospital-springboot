package com.hospital.domain;

import java.sql.Timestamp;

/**
 * @author liyu
 */
public class Prescription {
    private int id;
    private String name;
    private int docId;
    private Timestamp creatDate;

    /**
     * 数据库设计原因，暂定默认
     */
    private String range="全院";

    @Override
    public String toString() {
        return "Prescription{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", docId=" + docId +
                ", creatDate=" + creatDate +
                ", range='" + range + '\'' +
                '}';
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getDocId() {
        return docId;
    }

    public void setDocId(int docId) {
        this.docId = docId;
    }

    public Timestamp getCreatDate() {
        return creatDate;
    }

    public void setCreatDate(Timestamp creatDate) {
        this.creatDate = creatDate;
    }

    public String getRange() {
        return range;
    }

    public void setRange(String range) {
        this.range = range;
    }
}
