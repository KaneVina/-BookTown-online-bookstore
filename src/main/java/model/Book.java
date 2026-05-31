package model;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public class Book {
    private int bookID;
    private String title;
    private String description;
    private BigDecimal price;
    private int stockQuantity;
    private String thumbnail;
    private int totalPages;
    private String dimensions;
    private BigDecimal weight;
    private String status;

    // FK fields (loaded via JOIN)
    private int genreID;
    private String genreName;
    private int contentID;
    private String contentName;
    private int seriesID;
    private String seriesName;
    private int originID;
    private String originName;

    // Author (many-to-many via BookAuthor)
    private List<String> authors;

    // Timestamps
    private Date createdAt;
    private Date updatedAt;

    // Featured flag (không có trong DB, dùng để đánh dấu khi query)
    private boolean featured;

    // Average rating (computed)
    private double avgRating;
    private int reviewCount;

    public Book() {}

    // ── Getters & Setters ──────────────────────────────────────

    public int getBookID() { return bookID; }
    public void setBookID(int bookID) { this.bookID = bookID; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }

    public String getThumbnail() { return thumbnail; }
    public void setThumbnail(String thumbnail) { this.thumbnail = thumbnail; }

    public int getTotalPages() { return totalPages; }
    public void setTotalPages(int totalPages) { this.totalPages = totalPages; }

    public String getDimensions() { return dimensions; }
    public void setDimensions(String dimensions) { this.dimensions = dimensions; }

    public BigDecimal getWeight() { return weight; }
    public void setWeight(BigDecimal weight) { this.weight = weight; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getGenreID() { return genreID; }
    public void setGenreID(int genreID) { this.genreID = genreID; }

    public String getGenreName() { return genreName; }
    public void setGenreName(String genreName) { this.genreName = genreName; }

    public int getContentID() { return contentID; }
    public void setContentID(int contentID) { this.contentID = contentID; }

    public String getContentName() { return contentName; }
    public void setContentName(String contentName) { this.contentName = contentName; }

    public int getSeriesID() { return seriesID; }
    public void setSeriesID(int seriesID) { this.seriesID = seriesID; }

    public String getSeriesName() { return seriesName; }
    public void setSeriesName(String seriesName) { this.seriesName = seriesName; }

    public int getOriginID() { return originID; }
    public void setOriginID(int originID) { this.originID = originID; }

    public String getOriginName() { return originName; }
    public void setOriginName(String originName) { this.originName = originName; }

    public List<String> getAuthors() { return authors; }
    public void setAuthors(List<String> authors) { this.authors = authors; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    public boolean isFeatured() { return featured; }
    public void setFeatured(boolean featured) { this.featured = featured; }

    public double getAvgRating() { return avgRating; }
    public void setAvgRating(double avgRating) { this.avgRating = avgRating; }

    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }

    /** Trả về danh sách tác giả dạng chuỗi, ví dụ: "Nguyên Phong, Paulo Coelho" */
    public String getAuthorsDisplay() {
        if (authors == null || authors.isEmpty()) return "Đang cập nhật";
        return String.join(", ", authors);
    }
}