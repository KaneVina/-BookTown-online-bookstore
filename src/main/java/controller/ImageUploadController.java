package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import utils.CloudinaryUtil;

@MultipartConfig
public class ImageUploadController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            Part filePart = request.getPart("file");
            if (filePart == null || filePart.getSize() == 0) {
                sendJson(response, "{\"ok\":false,\"message\":\"Không có file được chọn\"}");
                return;
            }

            String fileName = filePart.getSubmittedFileName();
            byte[] fileBytes = filePart.getInputStream().readAllBytes();

            String folder = "booktown/products";
            String imageUrl = CloudinaryUtil.uploadImage(fileBytes, fileName, folder);

            if (imageUrl != null) {
                sendJson(response, "{\"ok\":true,\"url\":\"" + imageUrl + "\"}");
            } else {
                sendJson(response, "{\"ok\":false,\"message\":\"Upload thất bại\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendJson(response, "{\"ok\":false,\"message\":\"Lỗi: " + e.getMessage() + "\"}");
        }
    }

    private void sendJson(HttpServletResponse response, String json) throws IOException {
        PrintWriter out = response.getWriter();
        out.print(json);
    }
}