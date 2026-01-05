<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>SkyDrone Header</title>

            <!-- Bootstrap -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <!-- Icons -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
            <!-- Custom CSS -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/header.css">
        </head>

        <body>
            <c:set var="currentPage" value="${pageContext.request.requestURI}" />
            <!-- ==== HEADER TRÊN ==== -->
            <div class="header-bg">
                <div class="header-wrapper">
                    <header class="top-header">
                        <!-- LOGO -->
                        <a href="${pageContext.request.contextPath}/home">
                            <div class="logo">
                                <img src="${pageContext.request.contextPath}/image/logoo2.png" alt="Logo">
                                <h2>SkyDrone</h2>
                            </div>
                        </a>

                        <!-- THANH TÌM KIẾM -->
                        <form action="${pageContext.request.contextPath}/Searching" method="get"
                            class="search-bar position-relative">
                            <i class="bi bi-search" id="searchBtn" style="cursor: pointer;"></i>

                            <input id="searchInput" name="keyword" type="text" placeholder="Tìm kiếm drone, flycam..."
                                autocomplete="off" value="${keyword != null ? keyword : ''}">

                            <ul id="suggestList" class="list-group position-absolute w-100 shadow-sm"
                                style="top: 100%; left: 0; z-index: 1000; display: none;">
                            </ul>
                        </form>


                        <!-- HÀNH ĐỘNG HEADER -->
                        <div class="header-actions">

                            <!-- YÊU THÍCH -->
                            <a href="${pageContext.request.contextPath}/wishlist">
                                <div class="icon-btn ${currentPage.contains('/wishlist') ? 'active' : ''}"
                                    title="Yêu thích">
                                    <i class="bi bi-heart"></i>
                                    <span>Yêu thích</span>
                                </div>
                            </a>

                            <!-- GIỎ HÀNG -->
                            <a href="${pageContext.request.contextPath}/page/shoppingcart.jsp">
                                <div class="icon-btn ${currentPage.contains('shoppingcart') ? 'active' : ''}"
                                    title="Giỏ hàng">
                                    <i class="bi bi-cart3"></i>
                                    <span>Giỏ hàng</span>
                                </div>
                            </a>

                            <!-- TÀI KHOẢN -->
                            <a href="${pageContext.request.contextPath}/personal">
                                <div class="icon-btn ${currentPage.contains('/personal') ? 'active' : ''}"
                                    title="${not empty user ? user.username : 'Tài khoản'}">
                                    <i class="bi bi-person-circle"></i>
                                    <span>${not empty user ? user.username : 'Tài khoản'}</span>
                                </div>
                            </a>

                        </div>

                    </header>
                </div>
            </div>

            <!-- ==== MENU DƯỚI ==== -->
            <div class="menu-bg">
                <div class="header-wrapper">
                    <nav class="main-nav">

                        <a href="${pageContext.request.contextPath}/home">
                            <button class="nav-item ${currentPage.endsWith('homepage.jsp') ? 'active' : ''}">
                                <i class="bi bi-house-door"></i>Trang chủ
                            </button>
                        </a>

                        <button class="nav-item ${currentPage.contains('/category') ? 'active' : ''}" id="btnDanhMuc">
                            <i class="bi bi-grid"></i>Danh mục<i class="bi bi-caret-down-fill ms-1"></i>
                        </button>

                        <a href="${pageContext.request.contextPath}/page/promotion.jsp">
                            <button class="nav-item ${currentPage.endsWith('promotion.jsp') ? 'active' : ''}">
                                <i class="bi bi-gift"></i>Khuyến mãi
                            </button>
                        </a>

                        <a href="${pageContext.request.contextPath}/page/warranty.jsp">
                            <button class="nav-item ${currentPage.endsWith('warranty.jsp') ? 'active' : ''}">
                                <i class="bi bi-tools"></i>Bảo hành
                            </button>
                        </a>

                        <a href="${pageContext.request.contextPath}/page/payment-policy.jsp">
                            <button class="nav-item ${currentPage.endsWith('payment-policy.jsp') ? 'active' : ''}">
                                <i class="bi bi-credit-card"></i>Thanh toán
                            </button>
                        </a>

                        <a href="${pageContext.request.contextPath}/page/support.jsp">
                            <button class="nav-item ${currentPage.endsWith('support.jsp') ? 'active' : ''}">
                                <i class="bi bi-headset"></i>Hỗ trợ
                            </button>
                        </a>

                        <a href="${pageContext.request.contextPath}/blog">
                            <button class="nav-item ${currentPage.contains('/blog') ? 'active' : ''}">
                                <i class="bi bi-journal-text"></i>Bài viết
                            </button>
                        </a>

                    </nav>

                </div>
                <!-- MENU TRÁI ẨN MẶC ĐỊNH -->
                <div class="menu-left-1" id="menuLeft">
                    <ul>
                        <c:forEach items="${headerCategories}" var="cat">
                            <li>
                                <a href="${pageContext.request.contextPath}/Category?id=${cat.id}">
                                    <img src="${pageContext.request.contextPath}/${cat.image}"
                                         class="menu-icon">
                                        ${cat.categoryName}
                                </a>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>


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
            <script>
                const contextPath = '${pageContext.request.contextPath}';
                const searchInput = document.getElementById("searchInput");
                const suggestList = document.getElementById("suggestList");

                let debounceTimer = null;
                let isComposing = false;

                searchInput.addEventListener("compositionstart", () => {
                    isComposing = true;
                });

                searchInput.addEventListener("compositionend", () => {
                    isComposing = false;
                    triggerSuggest();
                });

                searchInput.addEventListener("input", () => {
                    if (!isComposing) triggerSuggest();
                });

                function triggerSuggest() {
                    const keyword = searchInput.value.trim();

                    if (keyword.length === 0) {
                        suggestList.style.display = "none";
                        suggestList.innerHTML = "";
                        return;
                    }

                    clearTimeout(debounceTimer);
                    debounceTimer = setTimeout(() => {
                        fetch(contextPath + "/search-suggestion?keyword=" + encodeURIComponent(keyword))
                            .then(res => res.json())
                            .then(data => {
                                suggestList.innerHTML = "";

                                if (!data || data.length === 0) {
                                    suggestList.style.display = "none";
                                    return;
                                }

                                data.forEach(item => {
                                    const li = document.createElement("li");
                                    li.className = "list-group-item list-group-item-action";
                                    li.innerHTML = highlightKeyword(item.name, keyword);

                                    li.onclick = () => {
                                        window.location.href =
                                            contextPath + "/product-detail?id=" + item.id;
                                    };

                                    suggestList.appendChild(li);
                                });

                                suggestList.style.display = "block";
                            });
                    }, 0);
                }


                document.addEventListener("click", (e) => {
                    if (!e.target.closest(".search-bar")) {
                        suggestList.style.display = "none";
                    }
                });

                function highlightKeyword(text, keyword) {
                    const regex = new RegExp("(" + keyword + ")", "gi");
                    return text.replace(regex, "<strong>$1</strong>");
                }
            </script>


        </body>

        </html>