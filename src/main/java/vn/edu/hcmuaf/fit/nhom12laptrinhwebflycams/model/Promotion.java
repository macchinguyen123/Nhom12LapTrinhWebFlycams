package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model;

import java.util.Date;

public class Promotion {
    private int id;
    private String name;
    private double discountValue;
    private enum discountType {Percent, Fixed};
    private Date startDate;
    private Date endDate;
}
