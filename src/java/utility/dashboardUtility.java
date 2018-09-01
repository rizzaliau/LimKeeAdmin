/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package utility;

import dao.ConnectionManager;
import entity.ItemDetails;
import entity.OrderItem;
import entity.SalesOrder;
import entity.SalesOrderDetails;
import entity.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

/**
 *
 * @author Rizza
 */
public class dashboardUtility {
    
    //Key Month, Value Revenue for a particular month
    public static Map<Integer, Double> getSalesRevenueByMonth(int year){
        
        Map<Integer, Double> salesRevenueByMonthMap = new HashMap<>();
        
        for(int month = 1; month<=12 ; month++){
        
            Map<Integer, SalesOrder> allSalesOrderRevenueMap = getAllRevenueSalesOrderMapByMonth(month,year);
            
            double totalForMonth = 0;
            
            for (Integer number : allSalesOrderRevenueMap.keySet()) {

                SalesOrder salesOrder = allSalesOrderRevenueMap.get(number);

                SalesOrderDetails salesOrderdetails = salesOrderUtility.getAllSalesOrderDetails(salesOrder.getOrderID());

                Map<Integer, ItemDetails> itemDetailsMap = salesOrderUtility.getItemDetailsMap(salesOrder.getOrderID(), salesOrderdetails.getStatus());
                
                for (Integer itemNumber : itemDetailsMap.keySet()) {
                    //double subtotal = 0;

                    ItemDetails itemDetail = itemDetailsMap.get(itemNumber);
                    //OrderItem item = salesOrderUtility.getOrderItem(itemDetail.getItemCode());

                    double qtyDouble = Double.parseDouble(itemDetail.getQty());
                    double unitPriceDouble = Double.parseDouble(itemDetail.getUnitPrice());

                    totalForMonth += qtyDouble *  unitPriceDouble;

                }

            }
            
            salesRevenueByMonthMap.put(month, totalForMonth);
        }   

        return salesRevenueByMonthMap;
    }
    
    //Key Month, Value SalesOrder for a particular month
    public static Map<Integer, SalesOrder> getAllRevenueSalesOrderMapByMonth(int month,int year){
        Map<Integer, SalesOrder> salesOrderMap = new HashMap<>();
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        int count = 1;
        
        try {
            conn = ConnectionManager.getConnection();
            
            String populateMap = "select so.OrderID, d.DebtorCode, d.DebtorName, d.RouteNumber from sales_order so \n" +
                "inner join debtor d on so.DebtorCode = d.DebtorCode  \n" +
                "inner join sales_order_detail sod on so.OrderID = sod.OrderID \n" +
                "where (so.Status = 'Pending Delivery' and MONTH(`CreatedTimeStamp`) = '"+month+"') and YEAR(`CreatedTimeStamp`) = '"+year+"' OR "
                    + "(so.Status = 'Delivered' and MONTH(`CreatedTimeStamp`) = '"+month+"') and YEAR(`CreatedTimeStamp`) = '"+year+"' "+
                "order by sod.DeliveryDate ASC, d.RouteNumber ASC";

            pstmt = conn.prepareStatement(populateMap);
            rs = pstmt.executeQuery();
            
            System.out.println("Passed connection");

            while (rs.next()) {
                
                String orderID = checkForNull(rs.getString("OrderID"));
                String debtorCode = checkForNull(rs.getString("DebtorCode"));
                String debtorName = checkForNull(rs.getString("DebtorName"));
                String routeNumber = checkForNull(rs.getString("RouteNumber"));

                SalesOrder salesOrder = new SalesOrder (orderID,debtorCode,debtorName,routeNumber);
                
                salesOrderMap.put(count, salesOrder);
                count++;
            }
            
        }catch(SQLException e){
            
            System.out.println("SQLException thrown by getSalesOrderMap method");
            System.out.println(e.getMessage());
            
        }finally{
            ConnectionManager.close(conn, pstmt, rs);
        }
        
        return salesOrderMap;
    
    }

    private static String checkForNull(String string){
       if(string == null || string.equals("null")){
           return "-";
       }
       return string;
   }
    
    //Key Rank, Value OrderItem Description
    public static Map<Integer, String> getTop5ProductsByMonth(int month,int year){
        
        //return map 
        Map<Integer, String> top5ProductsByMonth = new HashMap<>();
        
        //all sales orders for a particular month
        Map<Integer, SalesOrder> allSalesOrderMap = getAllRevenueSalesOrderMapByMonth(month,year);
        
        //List of all available order item (description)
        List<String> orderItemDiscriptionList = getOrderItemList();
        
        //key orderitem description, value quantiy of product ordered
        Map<String, Integer> getProductQtyForMonth = new HashMap<>();
        
        //Populate the getProductQtyForMonth Map for all the order items with 0 Quantity
        for (int i = 0; i< orderItemDiscriptionList.size(); i++) {
            getProductQtyForMonth.put(orderItemDiscriptionList.get(i), 0);
        }
        
        //loop through the all the sales order for a particular month
        for (Integer number : allSalesOrderMap.keySet()) {

            SalesOrder salesOrder = allSalesOrderMap.get(number);

            SalesOrderDetails salesOrderdetails = salesOrderUtility.getAllSalesOrderDetails(salesOrder.getOrderID());

            Map<Integer, ItemDetails> itemDetailsMap = salesOrderUtility.getItemDetailsMap(salesOrder.getOrderID(), salesOrderdetails.getStatus());
            
                for (Integer itemNumber : itemDetailsMap.keySet()) {

                    ItemDetails itemDetail = itemDetailsMap.get(itemNumber);
                    OrderItem item = salesOrderUtility.getOrderItem(itemDetail.getItemCode());
                    
                    String description = item.getDescription();
                    int qtyInt = Integer.parseInt(itemDetail.getQty());
                    
                    int newQuantity = getProductQtyForMonth.get(description)+qtyInt;
                    
                    getProductQtyForMonth.put(description, newQuantity);

                }
            
            
        }
        
        List<Entry<String, Integer>> list = new LinkedList<Entry<String, Integer>>(getProductQtyForMonth.entrySet());
        
        Collections.sort(list,new Comparator<Entry<String, Integer>>(){
            public int compare(Entry<String,Integer> o1, Entry<String, Integer> o2){
                return o1.getValue().compareTo(o2.getValue());
            }
        });
        
        int rank = 1;

        for (int k = list.size()-1; k>=list.size()-5; k--){    
            
            Entry<String, Integer> entry = list.get(k);
            
            String key = entry.getKey();
            int value = entry.getValue();
            
            System.out.println(entry);
            System.out.println("Key is "+key);
            
            top5ProductsByMonth.put(rank,key);
            rank++;
            
        }

        return top5ProductsByMonth;
    }
    
    //Get list of all availabe orderitems
    public static List<String> getOrderItemList(){
        
        List<String> orderItemsList = new ArrayList<>();
        
        Map<Integer, OrderItem> catalogueMap = salesOrderUtility.getCatalogueMap();
        
        for (Integer number : catalogueMap.keySet()) {
            OrderItem orderItem = catalogueMap.get(number);
            orderItemsList.add(orderItem.getDescription());

        }

        return orderItemsList;
    }
    
    //Key order description, Value qty for that particular month
    public static Map<String, Integer> getQtyForItemDescriptionMonth(int month, int year){
        
        //key orderitem description, value quantiy of product ordered
        Map<String, Integer> getProductQtyForMonth = new HashMap<>();
        
        //all sales orders for a particular month
        Map<Integer, SalesOrder> allSalesOrderMap = getAllRevenueSalesOrderMapByMonth(month,year);
        
        //List of all available order item (description)
        List<String> orderItemDiscriptionList = getOrderItemList();
        

        //Populate the getProductQtyForMonth Map for all the order items with 0 Quantity
        for (int i = 0; i< orderItemDiscriptionList.size(); i++) {
            getProductQtyForMonth.put(orderItemDiscriptionList.get(i), 0);
        }
        
        //loop through the all the sales order for a particular month
        for (Integer number : allSalesOrderMap.keySet()) {

            SalesOrder salesOrder = allSalesOrderMap.get(number);

            SalesOrderDetails salesOrderdetails = salesOrderUtility.getAllSalesOrderDetails(salesOrder.getOrderID());

            Map<Integer, ItemDetails> itemDetailsMap = salesOrderUtility.getItemDetailsMap(salesOrder.getOrderID(), salesOrderdetails.getStatus());
            
                for (Integer itemNumber : itemDetailsMap.keySet()) {

                    ItemDetails itemDetail = itemDetailsMap.get(itemNumber);
                    OrderItem item = salesOrderUtility.getOrderItem(itemDetail.getItemCode());
                    
                    String description = item.getDescription();
                    int qtyInt = Integer.parseInt(itemDetail.getQty());
                    
                    int newQuantity = getProductQtyForMonth.get(description)+qtyInt;
                    
                    getProductQtyForMonth.put(description, newQuantity);

                }
            
            
        }
        
        return getProductQtyForMonth;
    }
        
        
    public static Map<Integer, String> getMostReturnedProductsByMonth(int month,int year){
        
        //return map 
        Map<Integer, String> mostReturnedProductsByMonth = new HashMap<>();
        
        //all sales orders for a particular month
        Map<Integer, SalesOrder> allSalesOrderMap = getAllRevenueSalesOrderMapByMonth(month,year);
        
        //List of all available order item (description)
        List<String> orderItemDiscriptionList = getOrderItemList();
        
        //key orderitem description, value quantity of product ordered
        Map<String, Integer> getProductQtyForMonth = new HashMap<>();
        
        //key orderitem description, value returned quantity of product ordered
        Map<String, Integer> getReturnedProductQtyForMonth = new HashMap<>();
        
        //key orderitem description, value % returned quantity of product ordered
        Map<String, Double> getPercentageReturnedProductMap = new HashMap<>();
        
        //Populate the getProductQtyForMonth Map for all the order items with 0 Quantity
        for (int i = 0; i< orderItemDiscriptionList.size(); i++) {
            getProductQtyForMonth.put(orderItemDiscriptionList.get(i), 0);
        }
        
        for (int i = 0; i< orderItemDiscriptionList.size(); i++) {
            getReturnedProductQtyForMonth.put(orderItemDiscriptionList.get(i), 0);
        }
        
        //loop through the all the sales order for a particular month
        for (Integer number : allSalesOrderMap.keySet()) {

            SalesOrder salesOrder = allSalesOrderMap.get(number);

            SalesOrderDetails salesOrderdetails = salesOrderUtility.getAllSalesOrderDetails(salesOrder.getOrderID());

            Map<Integer, ItemDetails> itemDetailsMap = salesOrderUtility.getItemDetailsMap(salesOrder.getOrderID(), salesOrderdetails.getStatus());
            
                for (Integer itemNumber : itemDetailsMap.keySet()) {

                    ItemDetails itemDetail = itemDetailsMap.get(itemNumber);
                    OrderItem item = salesOrderUtility.getOrderItem(itemDetail.getItemCode());
                    
                    String description = item.getDescription();
                    int qtyInt = Integer.parseInt(itemDetail.getQty());
                    int returnedQtyInt = Integer.parseInt(itemDetail.getReturnedQty());
                    
                    int newQuantity = getProductQtyForMonth.get(description)+qtyInt;
                    int newReturnedQuantity = getReturnedProductQtyForMonth.get(description)+returnedQtyInt;
                    
                    getReturnedProductQtyForMonth.put(description, newReturnedQuantity);
                    getProductQtyForMonth.put(description, newQuantity);

                }
            
            
        }
        
        //Loop to calculate percentage of returned items
        for (String itemDescription : getProductQtyForMonth.keySet() ){
            double percentageReturned = 0;
            
            int qty = getProductQtyForMonth.get(itemDescription);
                    
            double returnedQty = getReturnedProductQtyForMonth.get(itemDescription);
            
            if(qty==0 && returnedQty ==0){
                getPercentageReturnedProductMap.put(itemDescription, 0.0);
            }else{
            
                percentageReturned = (returnedQty/(qty+returnedQty))*100;

                getPercentageReturnedProductMap.put(itemDescription, percentageReturned);

                //System.out.println("returnedQty is "+returnedQty);
                //System.out.println("Percentage Returned is"+percentageReturned);
            }
        }
        

        List<Entry<String, Double>> list = new LinkedList<Entry<String, Double>>(getPercentageReturnedProductMap.entrySet());
        
        Collections.sort(list,new Comparator<Entry<String, Double>>(){
            public int compare(Entry<String,Double> o1, Entry<String, Double> o2){
                return o1.getValue().compareTo(o2.getValue());
            }
        });
        
        int rank = 1;

        for (int k = list.size()-1; k>=list.size()-5; k--){    
            
            Entry<String, Double> entry = list.get(k);
            
            String key = entry.getKey();
            double value = entry.getValue();
            
            System.out.println(entry);
            System.out.println("Key is "+key);
            
            mostReturnedProductsByMonth.put(rank,key);
            rank++;
            
        }

        return mostReturnedProductsByMonth;
    }
    
    public static Map<String, Double> getReturnedQtyPercentageForItemDescriptionMonth(int month, int year){
        
        //key orderitem description, value % returned quantity of product ordered
        Map<String, Double> getPercentageReturnedProductMap = new HashMap<>();
        
        //all sales orders for a particular month
        Map<Integer, SalesOrder> allSalesOrderMap = getAllRevenueSalesOrderMapByMonth(month,year);
        
        //List of all available order item (description)
        List<String> orderItemDiscriptionList = getOrderItemList();
        
        //key orderitem description, value quantity of product ordered
        Map<String, Integer> getProductQtyForMonth = new HashMap<>();
        
        //key orderitem description, value returned quantity of product ordered
        Map<String, Integer> getReturnedProductQtyForMonth = new HashMap<>();
        

        //Populate the getProductQtyForMonth Map for all the order items with 0 Quantity
        for (int i = 0; i< orderItemDiscriptionList.size(); i++) {
            getProductQtyForMonth.put(orderItemDiscriptionList.get(i), 0);
        }
        
        for (int i = 0; i< orderItemDiscriptionList.size(); i++) {
            getReturnedProductQtyForMonth.put(orderItemDiscriptionList.get(i), 0);
        }
        
        //loop through the all the sales order for a particular month
        for (Integer number : allSalesOrderMap.keySet()) {

            SalesOrder salesOrder = allSalesOrderMap.get(number);

            SalesOrderDetails salesOrderdetails = salesOrderUtility.getAllSalesOrderDetails(salesOrder.getOrderID());

            Map<Integer, ItemDetails> itemDetailsMap = salesOrderUtility.getItemDetailsMap(salesOrder.getOrderID(), salesOrderdetails.getStatus());
            
                for (Integer itemNumber : itemDetailsMap.keySet()) {

                    ItemDetails itemDetail = itemDetailsMap.get(itemNumber);
                    OrderItem item = salesOrderUtility.getOrderItem(itemDetail.getItemCode());
                    
                    String description = item.getDescription();
                    int qtyInt = Integer.parseInt(itemDetail.getQty());
                    int returnedQtyInt = Integer.parseInt(itemDetail.getReturnedQty());
                    
                    int newQuantity = getProductQtyForMonth.get(description)+qtyInt;
                    int newReturnedQuantity = getReturnedProductQtyForMonth.get(description)+returnedQtyInt;
                    
                    getReturnedProductQtyForMonth.put(description, newReturnedQuantity);
                    getProductQtyForMonth.put(description, newQuantity);

                }
            
            
        }
        
        //Loop to calculate percentage of returned items
        for (String itemDescription : getProductQtyForMonth.keySet() ){
            double percentageReturned = 0;
            
            int qty = getProductQtyForMonth.get(itemDescription);
                    
            double returnedQty = getReturnedProductQtyForMonth.get(itemDescription);
            
            if(qty==0 && returnedQty ==0){
                getPercentageReturnedProductMap.put(itemDescription, 0.0);
            }else{
            
                percentageReturned = (returnedQty/(qty+returnedQty))*100;

                getPercentageReturnedProductMap.put(itemDescription, percentageReturned);

                //System.out.println("returnedQty is "+returnedQty);
                //System.out.println("Percentage Returned is"+percentageReturned);
            }
        }
        
        return getPercentageReturnedProductMap;
    }
    
    //Key index, Value Year
    public static Map<Integer, Integer> getAvailableSalesOrderYears(){    
    
        //String sql = "SELECT DISTINCT YEAR(CreatedTimeStamp) FROM sales_order Where so.Status = 'Pending Delivery'";
        Map<Integer,Integer> availableSalesOrderYears = new HashMap<>();
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        int count = 1;
        
        try {
            conn = ConnectionManager.getConnection();
            
            String populateMap = "select DISTINCT YEAR(CreatedTimeStamp) from sales_order so \n" +
                "inner join debtor d on so.DebtorCode = d.DebtorCode  \n" +
                "inner join sales_order_detail sod on so.OrderID = sod.OrderID \n" +
                "where so.Status = 'Pending Delivery' OR so.Status = 'Delivered'";

            pstmt = conn.prepareStatement(populateMap);
            rs = pstmt.executeQuery();
            
            System.out.println("Passed connection");

            while (rs.next()) {
                
                String year = checkForNull(rs.getString("YEAR(CreatedTimeStamp)"));
                int yearInt = Integer.parseInt(year);
                System.out.println(yearInt);
                
                availableSalesOrderYears.put(count, yearInt);
                count++;
            }
            
        }catch(SQLException e){
            
            System.out.println("SQLException thrown by getSalesOrderMap method");
            System.out.println(e.getMessage());
            
        }finally{
            ConnectionManager.close(conn, pstmt, rs);
        }
        
        return availableSalesOrderYears;
    }
}