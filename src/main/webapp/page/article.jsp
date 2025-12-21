<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${post.title}"/> - SkyDrone</title>
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/article.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/footer.css">

</head>
<body>
<jsp:include page="/page/header.jsp"/>

<article class="article-container">
    <header class="article-header">
        <div class="meta-info">
            <span class="post-date">
                <fmt:formatDate value="${post.createdAt}" pattern="dd/MM/yyyy" />
            </span>
            <span class="author">by Admin</span>
        </div>

        <h1 class="article-title">${post.title}</h1>
    </header>

    <div class="article-content">

        <!-- ẢNH BÀI VIẾT -->
        <div class="article-image">
            <img src="${post.image}" alt="${post.title}">
        </div>

        <!-- NỘI DUNG -->
        <div class="article-text" style="white-space: pre-line;">
        ${post.content}
    </div>





        <!-- Bài viết liên quan -->
        <section class="related-posts">
            <h3>Xem thêm bài viết khác:</h3>
            <ul>
                <c:forEach var="p" items="${relatedPosts}">
                    <li>
                        <a href="article?id=${p.id}">
                                ${p.title}
                        </a>
                    </li>
                </c:forEach>
            </ul>
        </section>

        <!-- Phần bình luận -->
        <section class="comment-section">
            <h2>Bình luận</h2>

            <!-- DANH SÁCH BÌNH LUẬN -->
            <c:forEach var="c" items="${comments}">
                <div class="card mb-3 shadow-sm">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <strong>
                                <i class="bi bi-person-circle"></i>
                                    ${c.username}
                            </strong>
                            <small class="text-muted">
                                <fmt:formatDate value="${c.createdAt}" pattern="dd/MM/yyyy"/>
                            </small>
                        </div>

                        <p class="mb-0">${c.content}</p>
                    </div>
                </div>
            </c:forEach>


            <!-- FORM BÌNH LUẬN -->
            <c:if test="${empty sessionScope.user}">
                <p><b>Bạn cần đăng nhập để bình luận.</b></p>
            </c:if>

            <c:if test="${not empty sessionScope.user}">
                <c:choose>
                    <c:when test="${hasReviewed}">
                        <p class="text-success">✔ Bạn đã bình luận bài viết này.</p>
                    </c:when>

                    <c:otherwise>
                        <form method="post"
                              action="${pageContext.request.contextPath}/BlogReview"
                              class="card p-3 shadow-sm">

                            <input type="hidden" name="blogId" value="${post.id}"/>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">
                                    Viết bình luận
                                </label>
                                <textarea name="content"
                                          class="form-control"
                                          rows="4"
                                          placeholder="Nhập bình luận của bạn..."
                                          required></textarea>
                            </div>

                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-send"></i> Gửi bình luận
                            </button>
                        </form>
                    </c:otherwise>
                </c:choose>
            </c:if>
        </section>

    </div>
</article>

<jsp:include page="/page/footer.jsp"/>
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>

    const btnDanhMuc = document.getElementById('btnDanhMuc');
    const menuLeft = document.getElementById('menuLeft');

    btnDanhMuc.addEventListener('click', () => {
        menuLeft.classList.toggle('show');
    });

    // Ẩn menu khi click ra ngoài
    document.addEventListener('click', (e) => {
        if (!menuLeft.contains(e.target) && !btnDanhMuc.contains(e.target)) {
            menuLeft.classList.remove('show');
        }
    });
</script>

</body>
</html>