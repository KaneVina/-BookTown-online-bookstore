package controller;

import dao.AddressDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Address;

public class AddressManagementController extends HttpServlet {

    private AddressDAO addressDAO = new AddressDAO();

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            request.setAttribute("addresses", addressDAO.getAllAddresses());
            request.getRequestDispatcher("/views/address/list.jsp")
                    .forward(request, response);
            return;
        }

        if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            request.setAttribute("address", addressDAO.getAddressById(id));
            request.getRequestDispatcher("/views/address/form.jsp")
                    .forward(request, response);
            return;
        }

        if ("create".equals(action)) {
            request.getRequestDispatcher("/views/address/form.jsp")
                    .forward(request, response);
            return;
        }

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            addressDAO.deleteAddress(id);
            response.sendRedirect("address");
            return;
        }

        if ("default".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            int customerID = Integer.parseInt(request.getParameter("customerID"));
            addressDAO.setDefaultAddress(id, customerID);
            response.sendRedirect("address");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String id = request.getParameter("id");

        Address a = new Address();
        a.setCustomerID(Integer.parseInt(request.getParameter("customerID")));
        a.setStreet(request.getParameter("street"));
        a.setDistrict(request.getParameter("district"));
        a.setCity(request.getParameter("city"));
        a.setCountry(request.getParameter("country"));
        a.setDefault(request.getParameter("isDefault") != null);

        if (id == null || id.isEmpty()) {
            addressDAO.insertAddress(a);
        } else {
            a.setAddressID(Integer.parseInt(id));
            addressDAO.updateAddress(a);
        }

        response.sendRedirect("address");
    }
}