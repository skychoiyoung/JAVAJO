package com.javajo.project.dto;

import java.io.Serializable;
import java.text.SimpleDateFormat;

public class HostQnaDTO implements Serializable {
	private int hostqna_num;
	private int house_num;
	private String hostqna_title;
	private String user_id;
	private String hostqna_gcontent;
	private String hostqna_hcontent;
	private String hostqna_status;
	private String hostqna_date;
	
	public int getHostqna_num() {
		return hostqna_num;
	}
	public void setHostqna_num(int hostqna_num) {
		this.hostqna_num = hostqna_num;
	}
	public int getHouse_num() {
		return house_num;
	}
	public void setHouse_num(int house_num) {
		this.house_num = house_num;
	}
	public String getHostqna_title() {
		return hostqna_title;
	}
	public void setHostqna_title(String hostqna_title) {
		this.hostqna_title = hostqna_title;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getHostqna_gcontent() {
		return hostqna_gcontent;
	}
	public void setHostqna_gcontent(String hostqna_gcontent) {
		this.hostqna_gcontent = hostqna_gcontent;
	}
	public String getHostqna_hcontent() {
		return hostqna_hcontent;
	}
	public void setHostqna_hcontent(String hostqna_hcontent) {
		this.hostqna_hcontent = hostqna_hcontent;
	}
	public String getHostqna_status() {
		return hostqna_status;
	}
	public void setHostqna_status(String hostqna_status) {
		this.hostqna_status = hostqna_status;
	}
	public String getHostqna_date() {
		return hostqna_date;
	}
	public void setHostqna_date(String hostqna_date) {
		this.hostqna_date = hostqna_date;
	}
	public String getOnlyDate() {
        return hostqna_date != null ? hostqna_date.split(" ")[0] : null;
    }
}
