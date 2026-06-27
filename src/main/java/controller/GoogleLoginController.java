package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigInteger;
import java.security.SecureRandom;
import java.net.URLEncoder;

public class GoogleLoginController extends HttpServlet {

    private static String CLIENT_ID;
    private static String CLIENT_SECRET;
    private static final String REDIRECT_URI = "http://localhost:8080/auth/google/callback";

    @Override
    public void init() throws ServletException {
        CLIENT_ID     = getServletContext().getInitParameter("GOOGLE_CLIENT_ID");
        CLIENT_SECRET = getServletContext().getInitParameter("GOOGLE_CLIENT_SECRET");

        if (CLIENT_ID == null || CLIENT_SECRET == null) {
            throw new ServletException(
                "Thiếu GOOGLE_CLIENT_ID hoặc GOOGLE_CLIENT_SECRET trong context.xml");
        }
    }

    public static String getClientId()     { return CLIENT_ID; }
    public static String getClientSecret() { return CLIENT_SECRET; }
    public static String getRedirectUri()  { return REDIRECT_URI; }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Tạo state ngẫu nhiên để chống CSRF
        String state = new BigInteger(130, new SecureRandom()).toString(32);
        HttpSession session = request.getSession();
        session.setAttribute("google_oauth_state", state);

        // Tạo URL redirect tới Google
        String googleAuthUrl = "https://accounts.google.com/o/oauth2/v2/auth"
                + "?client_id="    + URLEncoder.encode(CLIENT_ID,    "UTF-8")
                + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, "UTF-8")
                + "&response_type=code"
                + "&scope="        + URLEncoder.encode("openid email profile", "UTF-8")
                + "&state="        + URLEncoder.encode(state,        "UTF-8")
                + "&access_type=online";

        response.sendRedirect(googleAuthUrl);
    }
}