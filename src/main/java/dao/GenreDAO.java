package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Genre;
import utils.DBContext;

public class GenreDAO {

    DBContext db = new DBContext();

    public List<Genre> getAllGenres() {
        List<Genre> list = new ArrayList<>();
        String sql = "SELECT genreID, genre_name FROM Genre ORDER BY genreID DESC";

        try {
            Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Genre g = new Genre(
                        rs.getInt("genreID"),
                        rs.getString("genre_name")
                );
                list.add(g);
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Genre> searchGenres(String keyword) {
        List<Genre> list = new ArrayList<>();
        String sql = "SELECT genreID, genre_name FROM Genre WHERE genre_name LIKE ? ORDER BY genreID DESC";

        try {
            Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Genre g = new Genre(
                        rs.getInt("genreID"),
                        rs.getString("genre_name")
                );
                list.add(g);
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Genre getGenreById(int id) {
        String sql = "SELECT genreID, genre_name FROM Genre WHERE genreID = ?";

        try {
            Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Genre g = new Genre(
                        rs.getInt("genreID"),
                        rs.getString("genre_name")
                );
                conn.close();
                return g;
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public void insertGenre(String name) {
        String sql = "INSERT INTO Genre(genre_name) VALUES (?)";

        try {
            Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            System.out.println("INSERT = " + name);

            ps.executeUpdate();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateGenre(int id, String name) {
        String sql = "UPDATE Genre SET genre_name = ? WHERE genreID = ?";

        try {
            Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setInt(2, id);

            ps.executeUpdate();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteGenre(int id) {
        String sql = "DELETE FROM Genre WHERE genreID = ?";

        try {
            Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);

            ps.executeUpdate();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
