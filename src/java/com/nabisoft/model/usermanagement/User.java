package com.nabisoft.model.usermanagement;
  
import java.io.Serializable;
import java.util.Date;
import java.util.List;
 
import javax.persistence.Cacheable;
import javax.persistence.CollectionTable;
import javax.persistence.Column;
import javax.persistence.ElementCollection;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.UniqueConstraint;
 
import org.apache.commons.codec.digest.DigestUtils;

import com.nabisoft.model.usermanagement.dto.UserDTO;
 
@Entity
@Table(name="USERS")
@Cacheable(false)
public class User implements Serializable {
          
    @Id
    @Column(unique=true, nullable=false, length=128)
    private String email;
  
    @Column(nullable=false, length=128)
    private String firstName;
      
    @Column(nullable=false, length=128)
    private String lastName;
    
    @Column(nullable=false, length=128)
    private String place;
    
    @Column(nullable=false, length=128)
    private String birth;
    
    @Column(nullable=false, length=128)
    private String way;
    
    @Column(nullable=false, length=128)
    private String codFiscale;
    
    @Column(nullable=false, length=128)
    private String cellular;
    
    @Column(nullable=false, length=128)
    private String company;
    
    @Column(nullable=false, length=128)
    private String job;
    
    @Column(nullable=false, length=128)
    private String secretQ;
    
    @Column(nullable=false, length=128)
    private String secretR;
      
    /**
     * A sha512 is 512 bits long -- as its name indicates. If you are using an hexadecimal representation, 
     * each digit codes for 4 bits ; so you need 512 : 4 = 128 digits to represent 512 bits -- so, you need a varchar(128), 
     * or a char(128), as the length is always the same, not varying at all.
     */
    @Column(nullable=false, length=128) //sha-512 + hex
    private String password;
      
    @Temporal(javax.persistence.TemporalType.TIMESTAMP)
    @Column(nullable=false)
    private Date registeredOn;
          
    @ElementCollection(targetClass = Group.class)
    @CollectionTable(name = "USERS_GROUPS", 
                    joinColumns       = @JoinColumn(name = "email", nullable=false), 
                    uniqueConstraints = { @UniqueConstraint(columnNames={"email","groupname"}) } )
    @Enumerated(EnumType.STRING)
    @Column(name="groupname", length=64, nullable=false)
    private List<Group> groups;
     
    public User(){
         
    }
     
    public User(UserDTO user){
         
        if (user.getPassword1() == null || user.getPassword1().length() == 0
                || !user.getPassword1().equals(user.getPassword2()) )
            throw new RuntimeException("Password 1 and Password 2 have to be equal (typo?)");
         
        this.email        = user.getEmail();
        this.firstName    = user.getFName();
        this.lastName     = user.getLName();  
        this.place = user.getPlace();
        this.birth = user.getBirth();
        this.way = user.getWay();
        this.company = user.getCompany();
        this.codFiscale = user.getCodFiscale();
        this.cellular = user.getCellular();
        this.job = user.getJob();
        this.secretQ = user.getSecretQ();
        this.secretR = user.getSecretR();
        this.password     = DigestUtils.sha512Hex(user.getPassword1() );
        this.registeredOn = new Date();
    }
 
    public String getFirstName() {
        return firstName;
    }
 
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }
 
    public String getLastName() {
        return lastName;
    }
 
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
 
    public String getEmail() {
        return email;
    }
  
    public void setEmail(String email) {
        this.email = email;
    }
  
    /**
     * @return the password in SHA512 HEX representation
     */
    public String getPassword() {
        return password;
    }
 
    public void setPassword(String password) {
        this.password = password;
    }
 
    public Date getRegisteredOn() {
        return registeredOn;
    }
 
    public void setRegisteredOn(Date registeredOn) {
        this.registeredOn = registeredOn;
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
    
    public List<Group> getGroups() {
        return groups;
    }
 
    public void setGroups(List<Group> groups) {
        this.groups = groups;
    }
 
    @Override
    public String toString() {
        return "User [email=" + email + ", firstName=" + firstName
                + ", lastName=" + lastName + ", password=" + password
                + ", registeredOn=" + registeredOn + ", groups=" + groups + "]";
    }
}