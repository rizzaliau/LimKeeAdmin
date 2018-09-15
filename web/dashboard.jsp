
<%@page import="utility.adminUtility"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="utility.dashboardUtility"%>
<%@page import="utility.notificationUtility"%>
<%@page import="entity.Notification"%>
<%@page import="java.util.Map"%>
<!DOCTYPE html>

<%@include file="protect.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<html lang="en">

    <head>
        <meta charset="utf-8" />

        <link rel="apple-touch-icon" sizes="76x76" href="assets/img/apple-icon.png">
        <link rel="icon" type="image/png" href="assets/img/favicon.ico">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
        <title>Lim Kee Admin Portal</title>
        <meta content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0, shrink-to-fit=no' name='viewport' />
        <!--     Fonts and icons     -->
        <link href="https://fonts.googleapis.com/css?family=Montserrat:400,700,200" rel="stylesheet" />
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css" />
        <!-- CSS Files -->
        <link href="assets/css/bootstrap.min.css" rel="stylesheet" />
        <link href="assets/css/light-bootstrap-dashboard.css?v=2.0.1" rel="stylesheet" />
        <!-- CSS Just for demo purpose, don't include it in your project -->
        <link href="assets/css/demo.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://www.w3schools.com/lib/w3-colors-highway.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.6.0/Chart.min.js"></script>
        <!--tabs for the button-->
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
        <link rel='stylesheet' href='css/tabButton.css'/>
    </head>

    <body>
        <div class="wrapper">
            <!-- Sidebar -->
            <div class="sidebar" data-image="assets/img/navbar.png" data-color="orange">
                <!--
            Tip 1: You can change the color of the sidebar using: data-color="purple | blue | green | orange | red"
    
            Tip 2: you can also add an image using data-image tag
                -->
                <div class="sidebar-wrapper">
                    <div class="logo">
                        <a href="#" class="simple-text">
                            LIM KEE Admin Portal
                        </a>

                    </div>
                    <ul class="nav">
                        <%  String isMasterAdmin = (String) session.getAttribute("isMaster");

                            if (isMasterAdmin.equals("1")) {
                                out.print("<li>");
                                out.print("<a class='nav-link' href='admin.jsp'>");
                                out.print("<i class='nc-icon nc-key-25'></i>");
                                out.print("<p>Admin</p>");
                                out.print("</a>");
                                out.print("</li>");
                            }

                        %>
                        <li class='nav-item active'>
                            <a class="nav-link" href="dashboard.jsp">
                                <i class="nc-icon nc-chart-pie-35"></i>
                                <p>Dashboard</p>
                            </a>
                        </li>
                        <li>
                            <a class="nav-link" href="customer.jsp">
                                <i class="nc-icon nc-circle-09"></i>
                                <p>Customer</p>
                            </a>
                        </li>
                        <li>
                            <a class="nav-link" href="salesOrder.jsp">
                                <i class="nc-icon nc-notes"></i>
                                <p>Sales Order</p>
                            </a>
                        </li>
                        <li>
                            <a class="nav-link" href="catalogue.jsp">
                                <i class="nc-icon nc-paper-2"></i>
                                <p>Catalogue</p>
                            </a>
                        </li>
                        <li>
                            <a class="nav-link" href="loyaltyProgramme.jsp">
                                <i class="nc-icon nc-single-02"></i>
                                <p>Loyalty Programme</p>
                            </a>
                        </li>
                        <li>
                            <a class="nav-link" href="./accountSettings.jsp">
                                <i class="nc-icon nc-settings-gear-64"></i>
                                <p>Account Settings</p>
                            </a>
                        </li>

                    </ul>
                </div>
            </div>
            <!--End Sidebar -->     
            <div class="main-panel">
                <!-- Navbar -->
                <nav class="navbar navbar-expand-lg " color-on-scroll="500">
                    <div class=" container-fluid  ">
                        <a class="navbar-brand" href="#"><img src="assets/img/limkee_logo.png" style="margin-right: 10px; width:60px; height:42px;"/></a>
                        <button href="" class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" aria-controls="navigation-index" aria-expanded="false" aria-label="Toggle navigation">
                            <span class="navbar-toggler-bar burger-lines"></span>
                            <span class="navbar-toggler-bar burger-lines"></span>
                            <span class="navbar-toggler-bar burger-lines"></span>
                        </button>
                        <div class="collapse navbar-collapse justify-content-end" id="navigation">
                            <ul class="nav navbar-nav mr-auto">
                                <div id="notification">
                                    <li class="dropdown nav-item">
                                        <a href="#" class="dropdown-toggle nav-link" data-toggle="dropdown">
                                            <i class="nc-icon nc-planet"></i>
                                            <% Map<Integer, Notification> notificationMap = notificationUtility.getNotificationsMap();%>
                                            <span class="notification"> <%= notificationMap.size()%> </span>
                                            <span class="d-lg-none">Notification</span>
                                        </a>
                                        <ul class="dropdown-menu">

                                            <%
                                                //out.println("<div class='notification'>");
                                                for (int i = 1; i <= notificationMap.size(); i++) {
                                                    if (i <= 5) {
                                                        Notification notification = notificationMap.get(i);
                                                        out.print("<a class='dropdown-item' href='updateNotification.jsp?orderID=" + notification.getOrderID() + "'>" + notification.getDebtorName()
                                                                + "  placed a new order #" + notification.getOrderID() + " on " + notification.getFormattedCreatedTimeStamp() + "</a>");
                                                    }
                                                }
                                                //out.print("</div>");
                                                out.print("<center><a class='dropdown-item' href='allNotifications.jsp'>View all notifications</a></center>");

                                            %>  

                                        </ul>
                                    </li>
                                </div>
                            </ul>
                            <ul class="navbar-nav ml-auto">
                                <% String usernameSession = (String) session.getAttribute("username");%>
                                Welcome, <%= usernameSession%> 

                                <li class="nav-item">
                                    <a class="nav-link" href="logout.jsp">
                                        <span class="no-icon">Log out</span>
                                        <div id="show" align="center"></div>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </nav>
                <!-- End Navbar -->

                <div class="content">
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="card striped-tabled-with-hover">
                                    <div class="card-header ">
                                        <h4 class="card-title">Sales Revenue</h4>
                                        <p class="card-category">Sales Performance</p>
                                      
                                    </div>   

                                    <!-- HIDE THE BUTTON FIRST 
                                    <center>    
                                        <a href="dashboard.jsp"><input class="btn btn-info btn-fill pull-center" type="button" name="salesDashboard"  value="Sales" /></a>
                                        <a href="productDashboard.jsp"><input class="btn btn-info btn-fill pull-center" type="button" name="productDashboard"  value="Product"  /></a>
                                        <a href="customerDashboard.jsp"><input class="btn btn-info btn-fill pull-center" type="button" name="customerDashboard"  value="Customer"/></a>
                                    </center>
                                    -->
                                    <br>    

                                    <%
                                        // Resuable variables
                                        Map<Integer, Integer> availableSalesOrderYears = dashboardUtility.getAvailableSalesOrderYears();
                                        
                                        String currentTimeStamp = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());
                                        String currentMonth = adminUtility.getMonthTimestamp(currentTimeStamp);                                                
                                        String currentYear =  adminUtility.getYearTimestamp(currentTimeStamp);
                                        

                                    %>


                                    <div>
                                        <div class="col-md-4 pr-1">
                                            <div class="form-group">
                                                <!-- Filter year for total revenue -->
                                                <form method="post" action="dashboard.jsp" name="filterTotalSalesYearForm">

                                                    <select id="filterYear" name="yearTotalRevenue" onchange="return setValue();" class="form-control">

                                                        <%
                                                            out.print("<option value='none'>Select Year</option>");
                                                            for (int i = availableSalesOrderYears.size(); i >= 1; i--) {
                                                                int year = availableSalesOrderYears.get(i);

                                                                //out.print("<a href='filterSalesDashboard.jsp?year='"+year+"'>"+year+"</a>");
                                                                //out.print("<option value='filterSalesDashboard.jsp?year="+year+"' >"+year+"</option>");
                                                                out.print("<option value='" + year + "'>" + year + "");

                                                            }
                                                        %>

                                                    </select>


                                                    <input type="hidden" name="dropdown" id="dropdown">
                                                    <input type="submit" value="Filter" name="btn_dropdown" style="position: relative; left:155px; bottom:40px;" class="btn btn-info btn-fill pull-left" type="button">
                                                </form>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Total Revenue Chart -->
                                    <div class="container">
                                        <canvas id="totalRevenueChart"></canvas>
                                    </div>    

                                    <%
                                        Map<Integer, Double> salesRevenueByMonthMap = null;
                                        DecimalFormat df = new DecimalFormat("0.00");

                                        String yearRetrieved = request.getParameter("yearTotalRevenue");

                                        if (yearRetrieved == null) {
                                            salesRevenueByMonthMap = dashboardUtility.getSalesRevenueByMonth(2018);
                                            yearRetrieved = "2018";

                                        } else if (yearRetrieved.equals("none")) {
                                            salesRevenueByMonthMap = dashboardUtility.getSalesRevenueByMonth(2018);
                                            yearRetrieved = "2018";

                                        } else {
                                            int yearInt = Integer.parseInt(yearRetrieved);
                                            //map parameters month, revenue
                                            //hardcoded year to 2018
                                            salesRevenueByMonthMap = dashboardUtility.getSalesRevenueByMonth(yearInt);

                                        }
                                        
                                        
                                    %>    
                                    <center>
                                        <script>
                                            let totalRevenueChart = document.getElementById('totalRevenueChart').getContext('2d');

                                            // Global Options
                                            Chart.defaults.global.defaultFontFamily = 'Segoe UI';
                                            Chart.defaults.global.defaultFontSize = 12;
                                            Chart.defaults.global.defaultFontColor = 'black';

                                            let massPopChart = new Chart(totalRevenueChart, {
                                                type: 'line', // bar, horizontalBar, pie, line, doughnut, radar, polarArea
                                                data: {
                                                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                                                        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                                                        fontFamily: 'Segoe UI',
                                                        fontSize: 12,
                                                    
                                                    datasets: [{
                                                            label: 'Total Revenue Sales',
                                                                fontFamily: 'Segoe UI',
                                                                fontSize: 12,
                                                            data: [
                                                                <%= df.format(salesRevenueByMonthMap.get(1))%>,
                                                                <%= df.format(salesRevenueByMonthMap.get(2))%>,
                                                                <%= df.format(salesRevenueByMonthMap.get(3))%>,
                                                                <%= df.format(salesRevenueByMonthMap.get(4))%>,
                                                                <%= df.format(salesRevenueByMonthMap.get(5))%>,
                                                                <%= df.format(salesRevenueByMonthMap.get(6))%>,
                                                                <%= df.format(salesRevenueByMonthMap.get(7))%>,
                                                                <%= df.format(salesRevenueByMonthMap.get(8))%>,
                                                                <%= df.format(salesRevenueByMonthMap.get(9))%>,
                                                                <%= df.format(salesRevenueByMonthMap.get(10))%>,
                                                                <%= df.format(salesRevenueByMonthMap.get(11))%>,
                                                                <%= df.format(salesRevenueByMonthMap.get(12))%>
                                                            ],
                                                            //backgroundColor:'green',
                                                            backgroundColor: [
                                                                'rgba(245,104,41,100)',
                                                            ],
                                                            borderWidth: 1,
                                                            borderColor: '#777',
                                                            hoverBorderWidth: 3,
                                                            hoverBorderColor: '#000',
                                                            fontFamily: 'Segoe UI',
                                                            fontSize: 12,
                                                        }]
                                                },
                                                options: {
                                                    title: {
                                                        display: true,
                                                        text: 'Total Revenue Monthly Breakdown By Year <%= yearRetrieved%>',
                                                        fontSize: 12,
                                                        fontFamily: 'Segoe UI'

                                                    },
                                                    legend: {
                                                        display: true,
                                                        position: 'bottom',
                                                        fontFamily: 'Segoe UI',
                                                        fontSize: 12,
                                                        labels: {
                                                            fontColor: 'black'
                                                            
                                                        }
                                                    },
                                                    layout: {
                                                        padding: {
                                                            left: 0,
                                                            right: 0,
                                                            bottom: 0,
                                                            top: 0
                                                        }
                                                    },
                                                    tooltips: {
                                                        enabled: true,
                                                        fontFamily: 'Segoe UI',
                                                        fontSize: 12
                                                    },
                                                    scales: {
                                                        yAxes: [{
                                                                scaleLabel: {
                                                                    display: true,
                                                                    labelString: 'Revenue ($)',
                                                                    fontSize: 12,
                                                                    fontFamily: 'Segoe UI'
                                                                }
                                                            }],

                                                        xAxes: [{
                                                                scaleLabel: {
                                                                    display: true,
                                                                    labelString: 'Month',
                                                                    fontSize: 12,
                                                                    fontFamily: 'Segoe UI'
                                                                }
                                                            }]

                                                    }
                                                }
                                            });

                                        </script>
                                    </center>
                                    <br>
                                    <br>
                                    <br>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="card ">
                                    <div class="card-header ">
                                        <h4 class="card-title">Products</h4>
                                        <p class="card-category">Products Performance</p>
                                    </div>
                                    <div class="card-body ">
                                        <%
                                            //Map<Integer, Integer> availableSalesOrderYears = dashboardUtility.getAvailableSalesOrderYears(); 

                                            Map<Integer, String> allMonths = dashboardUtility.getAllMonths();
                                        %>   


                                        <!-- Filter month/year for top 5 Products -->
                                        <center>
                                            <form method="post" action="dashboard.jsp" name="filterYearForm"  >
                                                <div class="row">
                                                    <div class="col-md-5 pr-1">
                                                        <div class="form-group">
                                                            
                                                                <select id="filterYear" name="month" onchange="return setValue();" class="form-control">

                                                                    <%
                                                                        out.print("<option value='none'>Select Month</option>");
                                                                        for (int i = 1; i <= allMonths.size(); i++) {
                                                                            String month = allMonths.get(i);
                                                                            out.print("<option value='" + i + "'>" + month + "");

                                                                        }
                                                                    %>

                                                                </select>
                                                        </div>
                                                    </div>
                                                                   
                                                    <div class="col-md-5 pr-1">
                                                        <div class="form-group">
                                                            <select id="filterYear" name="year" onchange="return setValue();" class="form-control">

                                                                <%
                                                                    out.print("<option value='none'>Select Year</option>");
                                                                    for (int i = availableSalesOrderYears.size(); i >= 1; i--) {
                                                                        int year = availableSalesOrderYears.get(i);
                                                                        //out.print("<option value='"+year+"'>"+year+"</option>");
                                                                        //out.print("<a href='filterSalesDashboard.jsp?year='"+year+"'>"+year+"</a>");
                                                                        //out.print("<option value='filterSalesDashboard.jsp?year="+year+"' >"+year+"</option>");
                                                                        out.print("<option value='" + year + "'>" + year + "");

                                                                    }
                                                                %>

                                                            </select>
                                                                 </div>
                                                    </div>
                   
                                                <input type="hidden" name="dropdown" id="dropdown">
                                                <input type="submit" class="btn btn-info btn-fill pull-left" type="button" value="Filter" name="btn_dropdown" style="position: relative; left:2px;; height: 40px;">
                                                </form>
                                        </center>
                                        <br>

                                        <!-- Graph for top 5 Products -->
                                        <div class="container">
                                            <canvas id="getTop5ProductsChart" width="500" height="300"></canvas>
                                        </div>    

                                        <%
                                            //DecimalFormat df = new DecimalFormat("0.00");
                                            //Map<Integer, String> getTop5ProductsByMonth = dashboardUtility.getTop5ProductsByMonth(6,2018);
                                            Map<Integer, String> getTop5ProductsByMonth = null;
                                            Map<String, Integer> qtyForItemDescriptionMonthMap = null;

                                            //DecimalFormat df = new DecimalFormat("0.00");
                                            String yearRetrievedTop5 = request.getParameter("year");
                                            String monthRetrievedTop5 = request.getParameter("month");
                                            int monthInt = 1;

                                            if (yearRetrievedTop5 == null && monthRetrievedTop5 == null) {
                                                getTop5ProductsByMonth = dashboardUtility.getTop5ProductsByMonth(1, 2018);
                                                qtyForItemDescriptionMonthMap = dashboardUtility.getQtyForItemDescriptionMonth(1, 2018);

                                                //monthRetrievedTop5 = 1;
                                                yearRetrievedTop5 = "2018";
                                            } else if (yearRetrievedTop5.equals("none") && monthRetrievedTop5.equals("none")
                                                    || yearRetrievedTop5.equals("none") || monthRetrievedTop5.equals("none")) {

                                                getTop5ProductsByMonth = dashboardUtility.getTop5ProductsByMonth(1, 2018);
                                                qtyForItemDescriptionMonthMap = dashboardUtility.getQtyForItemDescriptionMonth(1, 2018);

                                                yearRetrievedTop5 = "2018";

                                            } else {
                                                int yearInt = Integer.parseInt(yearRetrievedTop5);
                                                monthInt = Integer.parseInt(monthRetrievedTop5);
                                                //map parameters month, revenue
                                                //hardcoded year to 2018
                                                getTop5ProductsByMonth = dashboardUtility.getTop5ProductsByMonth(monthInt, yearInt);
                                                qtyForItemDescriptionMonthMap = dashboardUtility.getQtyForItemDescriptionMonth(monthInt, yearInt);

                                            }


                                        %>
                                        <center>
                                            <script>
                                                let getTop5ProductsChart = document.getElementById('getTop5ProductsChart').getContext('2d');

                                                // Global Options
                                                Chart.defaults.global.defaultFontFamily = 'Segoe UI';
                                                Chart.defaults.global.defaultFontSize = 12;
                                                Chart.defaults.global.defaultFontColor = 'black';

                                                let massPopChart2 = new Chart(getTop5ProductsChart, {
                                                    type: 'pie', // bar, horizontalBar, pie, line, doughnut, radar, polarArea
                                                    data: {
                                                        labels: [
                                                            '<%= getTop5ProductsByMonth.get(1)%>',
                                                            '<%= getTop5ProductsByMonth.get(2)%>',
                                                            '<%= getTop5ProductsByMonth.get(3)%>',
                                                            '<%= getTop5ProductsByMonth.get(4)%>',
                                                            '<%= getTop5ProductsByMonth.get(5)%>'],
                                                                fontFamily: 'Segoe UI',
                                                                fontSize: 12,
                                                        datasets: [{
                                                                label: 'Total Revenue Sales',
                                                                fontFamily: 'Segoe UI',
                                                                fontSize: 12,
                                                                data: [
                                                <%= qtyForItemDescriptionMonthMap.get(getTop5ProductsByMonth.get(1))%>,
                                                <%= qtyForItemDescriptionMonthMap.get(getTop5ProductsByMonth.get(2))%>,
                                                <%= qtyForItemDescriptionMonthMap.get(getTop5ProductsByMonth.get(3))%>,
                                                <%= qtyForItemDescriptionMonthMap.get(getTop5ProductsByMonth.get(4))%>,
                                                <%= qtyForItemDescriptionMonthMap.get(getTop5ProductsByMonth.get(5))%>
                                                                ],
                                                                
                                                                //backgroundColor:'green',
                                                                backgroundColor: [
                                                                    'rgba(245, 104, 41, 1)',
                                                                    'rgba(14, 61, 89, 1)',
                                                                    'rgba(135, 166, 28,1)',
                                                                    'rgba(242, 159, 5, 1)',
                                                                    'rgba(217, 37, 38, 1)',
                                                                    'rgba(255, 159, 64, 0.6)',
                                                                    'rgba(255, 99, 132, 0.6)'
                                                                ],
                                                                borderWidth: 1,
                                                                borderColor: '#777',
                                                                hoverBorderWidth: 3,
                                                                hoverBorderColor: '#000',
                                                                fontFamily: 'Segoe UI',
                                                                fontSize: '12'
                                                            }]
                                                    },
                                                    options: {
                                                        title: {
                                                            display: true,
                                                            text: 'Top 5 Products by Volume <%= allMonths.get(monthInt)%> <%= yearRetrievedTop5%>',
                                                            fontFamily: 'Segoe UI',
                                                            fontSize: 12,
                                                    
                                                        },
                                                        legend: {
                                                            display: true,
                                                            position: 'bottom',
                                                            fontFamily: 'Segoe UI',
                                                            fontSize: 12,
                                                            
                                                            labels: {
                                                                fontColor: 'black',
                                                                fontFamily: 'Segoe UI',
                                                                fontSize: 12,
                                                            }
                                                        },
                                                        layout: {
                                                            padding: {
                                                                left: 0,
                                                                right: 0,
                                                                bottom: 0,
                                                                top: 0
                                                            }
                                                        },
                                                        tooltips: {
                                                            enabled: true,
                                                            fontFamily: 'Segoe UI',
                                                            fontSize: 12
                                                        }

                                                    }
                                                });

                                            </script>
                                        </center>
                                        <br>
                                        <br>

                                    </div>
                                </div>
                            </div>
                            <div class="col-md-12">
                                <div class="card ">
                                    <div class="card-header ">
                                        <h4 class="card-title">Return Products</h4>
                                        <p class="card-category">Return performances</p>
                                    </div>
                                    <div class="card-body ">
                                        <!--filter for Top 5 Most returned products -->
                                        <center>
                                             <div class="row">
                                                <div class="col-md-4 pr-1">
                                                    <div class="form-group">   
                                                <form method="post" action="dashboard.jsp" name="filterReturnedProductsForm">
                                                    <select id="filterYear" name="monthReturnedProducts" onchange="return setValue();" class="form-control">

                                                        <%
                                                            out.print("<option value='none'>Select Month");
                                                            for (int i = 1; i <= allMonths.size(); i++) {
                                                                String month = allMonths.get(i);
                                                                out.print("<option value='" + i + "'>" + month + "");

                                                            }
                                                        %>

                                                    </select>
                                                        
                                                    </div>
                                                </div>
                                                <div class="col-md-4 pr-1">
                                                    <div class="form-group">   
                                                    <select id="filterMonth" name="yearReturnedProducts" onchange="return setValue();" class="form-control" >

                                                        <%
                                                            out.print("<option value='none'>Select Year");
                                                            for (int i = availableSalesOrderYears.size(); i >= 1; i--) {
                                                                int year = availableSalesOrderYears.get(i);

                                                                out.print("<option value='" + year + "'>" + year + "");

                                                            }
                                                        %>

                                                    </select>
                                                    </div>
                                                </div>

                                                    <input type="hidden" name="dropdown" id="dropdown">
                                                    <input type="submit" value="Filter" name="btn_dropdown" class="btn btn-info btn-fill pull-left" type="button" style="position: relative; left:2px;; height: 40px;">
                                                </form>

                                                
                                            </div>
                                        </center>
                                        <br>                             
                                        <%
                                            // Hardcoded for month 6, june
                                            //Map<Integer, String> getMostReturnedProductsByMonth = dashboardUtility.getMostReturnedProductsByMonth(6,2018);
                                            //Map<String, Double> getMostReturnedProductsByMonthPercentage = dashboardUtility.getReturnedQtyPercentageForItemDescriptionMonth(6,2018);
                                            Map<Integer, String> getMostReturnedProductsByMonth = null;
                                            Map<String, Double> getMostReturnedProductsByMonthPercentage = null;

                                            //DecimalFormat df = new DecimalFormat("0.00");
                                            String yearProductReturnedRetrieved = request.getParameter("yearReturnedProducts");
                                            String monthProductReturnedRetrieved = request.getParameter("monthReturnedProducts");
                                            int monthReturnedInt = 1;

                                            if (yearProductReturnedRetrieved == null && monthProductReturnedRetrieved == null) {
                                                getMostReturnedProductsByMonth = dashboardUtility.getMostReturnedProductsByMonth(1, 2018);
                                                getMostReturnedProductsByMonthPercentage = dashboardUtility.getReturnedQtyPercentageForItemDescriptionMonth(6, 2018);

                                                //monthRetrieved = 1;
                                                yearProductReturnedRetrieved = "2018";

                                            } else if (yearProductReturnedRetrieved.equals("none") && monthProductReturnedRetrieved.equals("none")
                                                    || yearProductReturnedRetrieved.equals("none") || monthProductReturnedRetrieved.equals("none")) {

                                                getMostReturnedProductsByMonth = dashboardUtility.getMostReturnedProductsByMonth(1, 2018);
                                                getMostReturnedProductsByMonthPercentage = dashboardUtility.getReturnedQtyPercentageForItemDescriptionMonth(6, 2018);

                                                yearProductReturnedRetrieved = "2018";

                                            } else {
                                                int yearProductReturnedInt = Integer.parseInt(yearProductReturnedRetrieved);
                                                monthReturnedInt = Integer.parseInt(monthProductReturnedRetrieved);

                                                getMostReturnedProductsByMonth = dashboardUtility.getMostReturnedProductsByMonth(monthReturnedInt, yearProductReturnedInt);
                                                getMostReturnedProductsByMonthPercentage = dashboardUtility.getReturnedQtyPercentageForItemDescriptionMonth(monthReturnedInt, yearProductReturnedInt);

                                            }


                                        %>


                                        <!--Graph for Top 5 Most returned products -->
                                        <div class="container">
                                            <canvas id="mostReturnedChart"></canvas>
                                        </div> 


                                        <script>
                                            let mostReturnedChart = document.getElementById('mostReturnedChart').getContext('2d');

                                            // Global Options
                                            Chart.defaults.global.defaultFontFamily = 'Segoe UI';
                                            Chart.defaults.global.defaultFontSize = 12;
                                            Chart.defaults.global.defaultFontColor = 'black';

                                            let massPopChart3 = new Chart(mostReturnedChart, {
                                                type: 'horizontalBar', // bar, horizontalBar, pie, line, doughnut, radar, polarArea
                                                data: {
                                                    labels: [
                                                        '<%= getMostReturnedProductsByMonth.get(1)%>',
                                                        '<%= getMostReturnedProductsByMonth.get(2)%>',
                                                        '<%= getMostReturnedProductsByMonth.get(3)%>',
                                                        '<%= getMostReturnedProductsByMonth.get(4)%>',
                                                        '<%= getMostReturnedProductsByMonth.get(5)%>'],
                                                                fontFamily: 'Segoe UI',
                                                                fontSize: 12,
                                                    datasets: [{
                                                            label: '% Returned Rate',
                                                            fontFamily: 'Segoe UI',
                                                            fontSize: 12,
                                                            data: [
                                            <%= df.format(getMostReturnedProductsByMonthPercentage.get(getMostReturnedProductsByMonth.get(1)))%>,
                                            <%= df.format(getMostReturnedProductsByMonthPercentage.get(getMostReturnedProductsByMonth.get(2)))%>,
                                            <%= df.format(getMostReturnedProductsByMonthPercentage.get(getMostReturnedProductsByMonth.get(3)))%>,
                                            <%= df.format(getMostReturnedProductsByMonthPercentage.get(getMostReturnedProductsByMonth.get(4)))%>,
                                            <%= df.format(getMostReturnedProductsByMonthPercentage.get(getMostReturnedProductsByMonth.get(5)))%>
                                                            ],
                                                            //backgroundColor:'green',
                                                            backgroundColor: 'rgba(245,104,41,100)',
                                                            borderWidth: 1,
                                                            borderColor: '#777',
                                                            hoverBorderWidth: 3,
                                                            hoverBorderColor: '#000',
                                                            fontFamily: 'Segoe UI',
                                                            fontSize: 12,
                                                        }]
                                                },
                                                options: {
                                                    title: {
                                                        display: true,
                                                        text: 'Top 5 Most Returned Products <%= allMonths.get(monthReturnedInt)%> <%= yearProductReturnedRetrieved%>',
                                                        fontFamily: 'Segoe UI',
                                                        fontSize: 12,
                                                    },
                                                    legend: {
                                                        display: true,
                                                        position: 'bottom',
                                                        labels: {
                                                            fontColor: 'black',
                                                            fontFamily: 'Segoe UI',
                                                            fontSize: 12,
                                                        }
                                                    },
                                                    layout: {
                                                        padding: {
                                                            left: 0,
                                                            right: 0,
                                                            bottom: 0,
                                                            top: 0
                                                        }
                                                    },
                                                    tooltips: {
                                                        enabled: true,
                                                        fontFamily: 'Segoe UI',
                                                        fontSize: 12,
                                                    },
                                                    scales: {
                                                        yAxes: [{
                                                                scaleLabel: {
                                                                display: true,
                                                                labelString: 'Item Name',
                                                                fontFamily: 'Segoe UI',
                                                                fontSize: 12,
                                                                }
                                                            }],

                                                        xAxes: [{
                                                                scaleLabel: {
                                                                    display: true,
                                                                    labelString: 'Return Rate (%)',
                                                                    fontFamily: 'Segoe UI',
                                                                    fontSize: 12,
                                                                }
                                                            }]

                                                    }
                                                }
                                            });

                                        </script>
                                        <br>
                                    </div>
                                </div>
                            </div>

                       <!-- Start of Dashboard II charts -->  
                       
                       
                       <!-- Start of Filter month/year for top 10 Customers -->
                            <center>
                                <form method="post" action="dashboard.jsp" name="top10CustomersForm" >
                                    <div class="row">
                                        <div class="col-md-5 pr-1">
                                            <div class="form-group">
                                                    <select id="top10Year" name="top10CustomersMonth" onchange="return setValue();" class="form-control">

                                                        <%
                                                            out.print("<option value='none'>Select Month</option>");
                                                            for (int i = 1; i <= allMonths.size(); i++) {
                                                                String month = allMonths.get(i);
                                                                out.print("<option value='" + i + "'>" + month + "");

                                                            }
                                                        %>

                                                    </select>
                                            </div>
                                        </div>

                                        <div class="col-md-5 pr-1">
                                            <div class="form-group">
                                                <select id="top10Month" name="top10CustomersYear" onchange="return setValue();" class="form-control">

                                                    <%
                                                        out.print("<option value='none'>Select Year</option>");
                                                        for (int i = availableSalesOrderYears.size(); i >= 1; i--) {
                                                            int year = availableSalesOrderYears.get(i);
                                                            out.print("<option value='" + year + "'>" + year + "");

                                                        }
                                                    %>

                                                </select>
                                            </div>
                                        </div>

                                        <input type="hidden" name="dropdown" id="dropdown">
                                        <input type="submit" class="btn btn-info btn-fill pull-left" type="button" value="Filter" name="btn_dropdown" style="position: relative; left:2px;; height: 40px;">
                                    </form>
                            </center>
                            <br>
                         <!-- End of Filter month/year for top 10 Customers -->
                                        
                         <!-- Chart for top 10 Customers -->    
                        <div class="col-md-12">
                            <div class="card ">
                                <div class="card-header ">
                                    <h4 class="card-title">Top 10 Customers</h4>
                                    <p class="card-category">Customers Performance</p>
                                </div>
                                <div class="card-body ">    
                            <div class="container">
                                <canvas id="top10CustomersChart"></canvas>
                            </div> 
                            <br>
                                    
                                    <%
                                        //Key rank, String customer code
                                        Map<Integer, String> top10CustomersByYearMonth = null;
                                        
                                        Map<String, Double> allCustomerSalesByYearMonth = null;
                                        
                                        //Retrieve parameters from form
                                        String yearRetrievedTop10Customers = request.getParameter("top10CustomersYear");
                                        String monthRetrievedTop10Customers = request.getParameter("top10CustomersMonth");

                                        int top10MonthInt = 1;

                                        //out.println(yearRetrievedTop10Customers);
                                        //out.println(monthRetrievedTop10Customers);

                                        if (yearRetrievedTop10Customers == null && monthRetrievedTop10Customers == null) {

                                            top10CustomersByYearMonth = dashboardUtility.getTop10CustomersByYearMonth(2018,6);
                                            allCustomerSalesByYearMonth = dashboardUtility.getAllCustomerSalesByYearMonth(2018,6);

                                            yearRetrievedTop10Customers = "2018";

                                        } else if (yearRetrievedTop10Customers.equals("none") && monthRetrievedTop10Customers.equals("none")
                                                || yearRetrievedTop10Customers.equals("none") || monthRetrievedTop10Customers.equals("none")) {

                                            top10CustomersByYearMonth = dashboardUtility.getTop10CustomersByYearMonth(2018,6);
                                            allCustomerSalesByYearMonth = dashboardUtility.getAllCustomerSalesByYearMonth(2018,6);

                                            yearRetrievedTop10Customers = "2018";

                                        } else {
                                            int top10YearInt = Integer.parseInt(yearRetrievedTop10Customers);
                                            top10MonthInt = Integer.parseInt(monthRetrievedTop10Customers);
                                            //map parameters month, revenue
                                            //hardcoded year to 2018
                                            top10CustomersByYearMonth = dashboardUtility.getTop10CustomersByYearMonth(top10YearInt,top10MonthInt);
                                            allCustomerSalesByYearMonth = dashboardUtility.getAllCustomerSalesByYearMonth(top10YearInt,top10MonthInt);

                                        }

                                    %>    
                                    <center>
                                    <script>
                                      let myChart = document.getElementById('top10CustomersChart').getContext('2d');

                                      // Global Options
                                      Chart.defaults.global.defaultFontFamily = 'Segoe UI';
                                      Chart.defaults.global.defaultFontSize = 12;
                                      Chart.defaults.global.defaultFontColor = 'black';

                                      let massPopChart4 = new Chart(top10CustomersChart, {
                                        type:'horizontalBar', // bar, horizontalBar, pie, line, doughnut, radar, polarArea
                                        data:{
                                          labels:['<%= top10CustomersByYearMonth.get(1) %>',
                                                  '<%= top10CustomersByYearMonth.get(2) %>', 
                                                  '<%= top10CustomersByYearMonth.get(3) %>',
                                                  '<%= top10CustomersByYearMonth.get(4) %>',
                                                  '<%= top10CustomersByYearMonth.get(5) %>',
                                                  '<%= top10CustomersByYearMonth.get(6) %>',
                                                  '<%= top10CustomersByYearMonth.get(7) %>',
                                                  '<%= top10CustomersByYearMonth.get(8) %>',
                                                  '<%= top10CustomersByYearMonth.get(9) %>', 
                                                  '<%= top10CustomersByYearMonth.get(10)%>'],
                                                                fontFamily: 'Segoe UI',
                                                                fontSize: 12,
                                          datasets:[{
                                            label:'Sales By Customer ($)',
                                            data:[
                                              <%= allCustomerSalesByYearMonth.get(top10CustomersByYearMonth.get(1)) %>,
                                              <%= allCustomerSalesByYearMonth.get(top10CustomersByYearMonth.get(2)) %>,
                                              <%= allCustomerSalesByYearMonth.get(top10CustomersByYearMonth.get(3)) %>,
                                              <%= allCustomerSalesByYearMonth.get(top10CustomersByYearMonth.get(4)) %>,
                                              <%= allCustomerSalesByYearMonth.get(top10CustomersByYearMonth.get(5)) %>,
                                              <%= allCustomerSalesByYearMonth.get(top10CustomersByYearMonth.get(6)) %>,
                                              <%= allCustomerSalesByYearMonth.get(top10CustomersByYearMonth.get(7)) %>,
                                              <%= allCustomerSalesByYearMonth.get(top10CustomersByYearMonth.get(8)) %>,
                                              <%= allCustomerSalesByYearMonth.get(top10CustomersByYearMonth.get(9)) %>,
                                              <%= allCustomerSalesByYearMonth.get(top10CustomersByYearMonth.get(10)) %>
                                            ],
                                                                fontFamily: 'Segoe UI',
                                                                fontSize: 12,
                                            //backgroundColor:'green',
                                            backgroundColor:[
                                              'rgba(255, 99, 132, 0.6)',
                                              'rgba(54, 162, 235, 0.6)',
                                              'rgba(255, 206, 86, 0.6)',
                                              'rgba(75, 192, 192, 0.6)',
                                              'rgba(153, 102, 255, 0.6)',
                                              'rgba(255, 159, 64, 0.6)',
                                              'rgba(255, 99, 132, 0.6)'
                                            ],
                                            borderWidth:1,
                                            borderColor:'#777',
                                            hoverBorderWidth:3,
                                            hoverBorderColor:'#000',
                                            fontFamily: 'Segoe UI',
                                            fontSize: 12,
                                          }]
                                        },
                                        options:{
                                          title:{
                                            display:true,
                                            text:'Top 10 Customers <%= allMonths.get(top10MonthInt)%> <%= yearRetrievedTop10Customers%> ',
                                            fontFamily: 'Segoe UI',
                                            fontSize: 12,
                                            
                                          },
                                          legend:{
                                            display:true,
                                            position:'bottom',
                                            fontFamily: 'Segoe UI',
                                            fontSize: 12,
                                            labels:{
                                              fontColor:'#000',
                                              fontFamily: 'Segoe UI',
                                              fontSize: 12,
                                            }
                                          },
                                          layout:{
                                            padding:{
                                              left:0,
                                              right:0,
                                              bottom:0,
                                              top:0
                                            }
                                          },
                                          tooltips:{
                                            enabled:true,
                                            fontFamily: 'Segoe UI',
                                            fontSize: 12,
                                          },
                                          scales: {
                                            yAxes: [{
                                              scaleLabel: {
                                                display: true,
                                                labelString: 'Customer Code',
                                                fontFamily: 'Segoe UI',
                                                fontSize: 12,
                                              }
                                            }],

                                            xAxes: [{
                                              scaleLabel: {
                                                display: true,
                                                labelString: 'Sales ($)',
                                                fontFamily: 'Segoe UI',
                                                fontSize: 12,
                                              }
                                            }]

                                          } 
                                        }
                                      });
                                      
                                    </script>
                                    </center>
                                    <br>

                                </div>
                            </div>
                        </div>
                                    <div class="col-md-12">
                            <div class="card ">
                                <div class="card-header ">
                                    <h4 class="card-title">2017 Sales</h4>
                                    <p class="card-category">All products including Taxes</p>
                                </div>
                                <div class="card-body ">
                                    <div class="container">
                                      <canvas id="customerWhoDoNotMeetRequirement"></canvas>
                                    </div> 
                                    
                                    <script>
                                      let customerWhoDoNotMeetRequirement = document.getElementById('customerWhoDoNotMeetRequirement').getContext('2d');
                                      // Global Options
                                      Chart.defaults.global.defaultFontFamily = 'Lato';
                                      Chart.defaults.global.defaultFontSize = 18;
                                      Chart.defaults.global.defaultFontColor = '#777';

                                      let massPopChart5 = new Chart(customerWhoDoNotMeetRequirement, {
                                        type:'horizontalBar', // bar, horizontalBar, pie, line, doughnut, radar, polarArea
                                        data:{
                                          labels:['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                                            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                                          datasets:[{
                                            label:'Sales By Customer ($)',
                                            data:[
                                              <%= 0 %>,
                                              <%= 0 %>,
                                              <%= 0 %>,
                                              <%= 0 %>,
                                              <%= 0 %>,
                                              <%= 10 %>,
                                              <%= 0 %>,
                                              <%= 0 %>,
                                              <%= 0 %>,
                                              <%= 0 %>,
                                              <%= 0 %>,
                                              <%= 0 %>
                                            ],
                                            //backgroundColor:'green',
                                            backgroundColor:'green',
                                            borderWidth:1,
                                            borderColor:'#777',
                                            hoverBorderWidth:3,
                                            hoverBorderColor:'#000'
                                          }]
                                        },
                                        options:{
                                          title:{
                                            display:true,
                                            text:'Customers Do Not Meet Requirements By Month',
                                            fontSize:25
                                          },
                                          legend:{
                                            display:true,
                                            position:'right',
                                            labels:{
                                              fontColor:'#000'
                                            }
                                          },
                                          layout:{
                                            padding:{
                                              left:50,
                                              right:0,
                                              bottom:0,
                                              top:0
                                            }
                                          },
                                          tooltips:{
                                            enabled:true
                                          },
                                          scales: {
                                            yAxes: [{
                                              scaleLabel: {
                                                display: true,
                                                labelString: 'Customer Code'
                                              }
                                            }],

                                            xAxes: [{
                                              scaleLabel: {
                                                display: true,
                                                labelString: 'Sales ($)'
                                              }
                                            }]

                                          } 
                                        }
                                      });
                                      
                                    </script>
                                    <br>
                                    <br>
                                </div>
                            </div>
                        </div>
                                            
                        <div class="col-md-12">
                            <div class="card ">
                                <div class="card-header ">
                                    <h4 class="card-title">2017 Sales</h4>
                                    <p class="card-category">All products including Taxes</p>
                                </div>
                                <div class="card-body ">
                                    <div class="container">
                                      <canvas id="returnProductsByCustomerChart"></canvas>
                                    </div>    

                                    <script>
                                      let returnProductsByCustomerChart = document.getElementById('returnProductsByCustomerChart').getContext('2d');

                                      // Global Options
                                      Chart.defaults.global.defaultFontFamily = 'Lato';
                                      Chart.defaults.global.defaultFontSize = 18;
                                      Chart.defaults.global.defaultFontColor = '#777';

                                      let massPopChart6 = new Chart(returnProductsByCustomerChart, {
                                        type:'line', // bar, horizontalBar, pie, line, doughnut, radar, polarArea
                                        data:{
                                          labels:['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                                            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                                          datasets:[{
                                            label:'Returned Products By Customers',
                                            data:[
                                              <%= salesRevenueByMonthMap.get(1) %>,
                                              <%= salesRevenueByMonthMap.get(2) %>,
                                              <%= salesRevenueByMonthMap.get(3) %>,
                                              <%= salesRevenueByMonthMap.get(4) %>,
                                              <%= salesRevenueByMonthMap.get(5) %>,
                                              <%= salesRevenueByMonthMap.get(6) %>,
                                              <%= salesRevenueByMonthMap.get(7) %>,
                                              <%= salesRevenueByMonthMap.get(8) %>,
                                              <%= salesRevenueByMonthMap.get(9) %>,
                                              <%= salesRevenueByMonthMap.get(10) %>,
                                              <%= salesRevenueByMonthMap.get(11) %>,
                                              <%= salesRevenueByMonthMap.get(12) %>
                                            ],
                                            //backgroundColor:'green',
                                            backgroundColor:['white'
                                            ],
                                            borderWidth:2,
                                            borderColor:'#FFA500',
                                            hoverBorderWidth:3,
                                            hoverBorderColor:'#000'
                                          }]
                                        },
                                        options:{
                                          title:{
                                            display:true,
                                            text:'Returned Products By Customers By Month',
                                            fontSize:25
                                          },
                                          legend:{
                                            display:true,
                                            position:'right',
                                            labels:{
                                              fontColor:'#000'
                                            }
                                          },
                                          layout:{
                                            padding:{
                                              left:50,
                                              right:0,
                                              bottom:0,
                                              top:0
                                            }
                                          },
                                          tooltips:{
                                            enabled:true
                                          },
                                          scales: {
                                            yAxes: [{
                                              scaleLabel: {
                                                display: true,
                                                labelString: 'Return Quantity'
                                              }
                                            }],

                                            xAxes: [{
                                              scaleLabel: {
                                                display: true,
                                                labelString: 'Month'
                                              }
                                            }]

                                          } 
                                        }
                                      });
                                      
                                    </script>
                                    <br>
                                    <br>
                                    <center>
                                    Breakdown Of Products Return
                                    <br>
                                    Note: Table with Columns Item Name, Original Qty and Returned Qty to be Inserted
                                    </center>
                                    <br>
                                </div>
                            </div>
                        </div>
                                                        
                                                        
                                                        
                                  <!-- End of Dashboard II charts -->                          
                                                        

                        </div>
                    </div>
                </div>



                <footer class="footer">
                    <div class="container">
                        <nav>

                            <p class="copyright text-center">
                                This website's content is Copyright 
                                <script>
                                    document.write(new Date().getFullYear())
                                </script>
                                © Lim Kee Food Manufacturing Pte Ltd
                            </p>
                        </nav>
                    </div>
                </footer>
            </div>
        </div>

    </body>
    <!--   Core JS Files   -->
    <script src="assets/js/core/jquery.3.2.1.min.js" type="text/javascript"></script>
    <script src="assets/js/core/popper.min.js" type="text/javascript"></script>
    <script src="assets/js/core/bootstrap.min.js" type="text/javascript"></script>
    <!--  Plugin for Switches, full documentation here: http://www.jque.re/plugins/version3/bootstrap.switch/ -->
    <script src="assets/js/plugins/bootstrap-switch.js"></script>
    <!--  Google Maps Plugin    -->
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=YOUR_KEY_HERE"></script>
    <!--  Chartist Plugin  -->
    <script src="assets/js/plugins/chartist.min.js"></script>
    <!--  Notifications Plugin    -->
    <script src="assets/js/plugins/bootstrap-notify.js"></script>
    <!-- Control Center for Light Bootstrap Dashboard: scripts for the example pages etc -->
    <script src="assets/js/light-bootstrap-dashboard.js?v=2.0.1" type="text/javascript"></script>
    <!-- Light Bootstrap Dashboard DEMO methods, don't include it in your project! -->
    <script src="assets/js/demo.js"></script>
    <!--<script type="text/javascript">
        $(document).ready(function() {
            // Javascript method's body can be found in assets/js/demos.js
            demo.initDashboardPageCharts();
    
            demo.showNotification();
    
        });
    </script>-->

    <script>
                                    $(document).ready(
                                            function () {
                                                setInterval(function () {
                                                    $('#notification').load('loyaltyProgramme.jsp #notification');
                                                }, 5000);
                                            });
    </script>

    <!--tabs button jquery script -->
    <script>
        document.getElementById('my_selection').onchange = function () {
            window.location.href = this.children[this.selectedIndex].getAttribute('href');
        }
    </script>



</html>