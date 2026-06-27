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

    // ======================================================================
    // ⚠️  THAY 2 GIÁ TRỊ NÀY bằng Client ID và Client Secret của bạn
    // ======================================================================
    private static final String CLIENT_ID = System.getenv("GOOGLE_CLIENT_ID");
    private static final String CLIENT_SECRET = System.getenv("GOOGLE_CLIENT_SECRET");

    // Phải khớp với URI bạn đã khai báo trên Google Console
    private static final String REDIRECT_URI  = "http://localhost:8080/auth/google/callback";

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
                + "?client_id="     + URLEncoder.encode(CLIENT_ID,    "UTF-8")
                + "&redirect_uri="  + URLEncoder.encode(REDIRECT_URI, "UTF-8")
                + "&response_type=code"
                + "&scope="         + URLEncoder.encode("openid email profile", "UTF-8")
                + "&state="         + URLEncoder.encode(state,        "UTF-8")
                + "&access_type=online";

        response.sendRedirect(googleAuthUrl);
    }
}