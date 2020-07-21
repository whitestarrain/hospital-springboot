package com.hospital.vo;

/**
 * @author liyu
 */
public class VoRegister {
    private String regiDate;
    private int depaId;
    private int status;
    private int id;
    private String depaName;

    @Override
    public String toString() {
        return "VoRegister{" +
                "regiDate='" + regiDate + '\'' +
                ", depaId=" + depaId +
                ", status=" + status +
                ", id=" + id +
                ", depaName='" + depaName + '\'' +
                '}';
    }

    public String getRegiDate() {
        return regiDate;
    }

    public void setRegiDate(String regiDate) {
        this.regiDate = regiDate;
    }

    public int getDepaId() {
        return depaId;
    }

    public void setDepaId(int depaId) {
        this.depaId = depaId;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getDepaName() {
        return depaName;
    }

    public void setDepaName(String depaName) {
        this.depaName = depaName;
    }
}
