package com.javajo.project.dto;

public class ReservDTO {
    private int reserv_num;
    private int house_num;
    private String house_name;
    private String user_id;
    private String reserv_status;
    private String reserv_date;
    private String reserv_checkin;
    private String reserv_checkout;
    private int reserv_person;
    private int reserv_pay;
    private int reserv_paycharge;
    private int reserv_totpay;
    private String reserv_paydate;
    private String reserv_paytype;

    // 조인테이블 컬럼
    private String host_id;
    private String thumbnail;
    private String review_status;
    
    // 새로운 필드
    private String reserv_month;
    private int totalReservPay;
    private int totalReservPaycharge;

    public int getReserv_num() {
        return reserv_num;
    }
    public void setReserv_num(int reserv_num) {
        this.reserv_num = reserv_num;
    }
    public int getHouse_num() {
        return house_num;
    }
    public void setHouse_num(int house_num) {
        this.house_num = house_num;
    }
    public String getHouse_name() {
        return house_name;
    }
    public void setHouse_name(String house_name) {
        this.house_name = house_name;
    }
    public String getUser_id() {
        return user_id;
    }
    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }
    public String getReserv_status() {
        return reserv_status;
    }
    public void setReserv_status(String reserv_status) {
        this.reserv_status = reserv_status;
    }
    public String getReserv_date() {
        return reserv_date;
    }
    public void setReserv_date(String reserv_date) {
        this.reserv_date = reserv_date;
    }
    public String getReserv_checkin() {
        return reserv_checkin;
    }
    public void setReserv_checkin(String reserv_checkin) {
        this.reserv_checkin = reserv_checkin;
    }
    public String getReserv_checkout() {
        return reserv_checkout;
    }
    public void setReserv_checkout(String reserv_checkout) {
        this.reserv_checkout = reserv_checkout;
    }
    public int getReserv_person() {
        return reserv_person;
    }
    public void setReserv_person(int reserv_person) {
        this.reserv_person = reserv_person;
    }
    public int getReserv_pay() {
        return reserv_pay;
    }
    public void setReserv_pay(int reserv_pay) {
        this.reserv_pay = reserv_pay;
    }
    public int getReserv_paycharge() {
        return reserv_paycharge;
    }
    public void setReserv_paycharge(int reserv_paycharge) {
        this.reserv_paycharge = reserv_paycharge;
    }
    public int getReserv_totpay() {
        return reserv_totpay;
    }
    public void setReserv_totpay(int reserv_totpay) {
        this.reserv_totpay = reserv_totpay;
    }
    public String getReserv_paydate() {
        return reserv_paydate;
    }
    public void setReserv_paydate(String reserv_paydate) {
        this.reserv_paydate = reserv_paydate;
    }
    public String getReserv_paytype() {
        return reserv_paytype;
    }
    public void setReserv_paytype(String reserv_paytype) {
        this.reserv_paytype = reserv_paytype;
    }
    public int WeekendPay() {
        return (int) (reserv_pay * 1.1);
    }
    public int PeakSeasonPay() {
        return (int) (reserv_pay * 1.5);
    }

    // 조인테이블 getter, setter
    public String getHost_id() {
        return host_id;
    }
    public void setHost_id(String host_id) {
        this.host_id = host_id;
    }
    public String getThumbnail() {
        return thumbnail;
    }
    public void setThumbnail(String thumbnail) {
        this.thumbnail = thumbnail;
    }
    public String getReview_status() {
        return review_status;
    }
    public void setReview_status(String review_status) {
        this.review_status = review_status;
    }
	public String getReserv_month() {
		return reserv_month;
	}
	public void setReserv_month(String reserv_month) {
		this.reserv_month = reserv_month;
	}
	public int getTotalReservPay() {
		return totalReservPay;
	}
	public void setTotalReservPay(int totalReservPay) {
		this.totalReservPay = totalReservPay;
	}
	public int getTotalReservPaycharge() {
		return totalReservPaycharge;
	}
	public void setTotalReservPaycharge(int totalReservPaycharge) {
		this.totalReservPaycharge = totalReservPaycharge;
	}

    
}
