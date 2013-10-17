/**
 * Mon Jun 22 16:17:45 2013
 *
 * @author Simone Amoroso
 * @author Davide Pellegrino
 * @author Pierluigi Scarpetta
 * @author Mauro Vuolo
 *
 * Released under the Apache License, Version 2.0
 */
package com.ti_led.model.usermanagement.dto;
 
public class UserDTO {
 
    private String email;
    private String fName;
    private String lName;
    private String place;
    private String birth;
    private String way;
    private String codFiscale;
    private String cellular;
    private String company;
    private String job;
    private String secretQ;
    private String secretR;
    private String password1;
    private String password2;
    private String utilityKey;
     
    public String getFName() {
        return fName;
    }
     
    public void setFName(String firstName) {
        this.fName = firstName;
    }
  
    public String getLName() {
        return lName;
    }
  
    public void setLName(String lastName) {
        this.lName = lastName;
    }
  
    public String getEmail() {
        return email;
    } 
 
    public void setEmail(String email) {
        this.email = email;
    }
  
    public String getPassword1() {
        return password1;
    }
     
    public void setPassword1(String password) {
        this.password1 = password;
    }
     
    public String getPassword2() {
        return password2;
    }
     
    public void setPassword2(String password) {
        this.password2 = password;
    }
    
    public String getUtilityKey() {
        return utilityKey;
    }
     
    public void setUtilityKey(String utilityKey) {
        this.utilityKey = utilityKey;
    }
    
    public String getPlace() {
        return place;
    }
 
    public void setPlace(String place) {
        this.place = place;
    }
    
    public String getBirth() {
        return birth;
    }
 
    public void setBirth(String birth) {
        this.birth = birth;
    }
    
    public String getWay() {
        return way;
    }
 
    public void setWay(String way) {
        this.way = way;
    }
    
    public String getCodFiscale() {
        return codFiscale;
    }
 
    public void setCodFiscale(String codFiscale) {
        this.codFiscale = codFiscale;
    }
    
    public String getCellular() {
        return cellular;
    }
 
    public void setCellular(String cellular) {
        this.cellular = cellular;
    }
    
    public String getCompany() {
        return company;
    }
 
    public void setCompany(String company) {
        this.company = company;
    }
    
    public String getJob() {
        return job;
    }
 
    public void setJob(String job) {
        this.job = job;
    }
    
    public String getSecretQ() {
        return secretQ;
    }
 
    public void setSecretQ(String secretQ) {
        this.secretQ = secretQ;
    }
    
    public String getSecretR() {
        return secretR;
    }
 
    public void setSecretR(String secretR) {
        this.secretR = secretR;
    }
      
    @Override
    public String toString() {
        return "User [email=" + email + ", fName=" + fName
                + ", lName=" + lName + ", password1=" + password1 +", password2=" + password2 + "]";
    }
     
}