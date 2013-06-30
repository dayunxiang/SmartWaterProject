package com.nabisoft.model.usermanagement.dto;
 
public class UserDTO {
 
    private String email;
    private String fName;
    private String lName;
    private String password1;
    private String password2;
     
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
      
    @Override
    public String toString() {
        return "User [email=" + email + ", fName=" + fName
                + ", lName=" + lName + ", password1=" + password1 +", password2=" + password2 + "]";
    }
     
}