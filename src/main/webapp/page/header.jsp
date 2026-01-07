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
<c:set var="currentPage" value="${pageContext.request.requestURI}"/>
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

            <a href="${pageContext.request.contextPath}/promotion">
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
    // Thay thế toàn bộ phần <script> thứ 2 trong header.jsp

    const contextPath = '${pageContext.request.contextPath}';
    const searchInput = document.getElementById("searchInput");
    const suggestList = document.getElementById("suggestList");

    let debounceTimer = null;
    let isComposing = false;

    // ==== QUẢN LÝ LỊCH SỬ TÌM KIẾM ====
    const SearchHistory = {
        maxItems: 10,
        storageKey: 'skydrone_search_history',

        get: function() {
            try {
                const history = localStorage.getItem(this.storageKey);
                return history ? JSON.parse(history) : [];
            } catch (e) {
                return [];
            }
        },

        save: function(history) {
            try {
                localStorage.setItem(this.storageKey, JSON.stringify(history));
            } catch (e) {
                console.error('Không thể lưu lịch sử tìm kiếm', e);
            }
        },

        add: function(keyword) {
            keyword = keyword.trim();
            if (!keyword) return;

            let history = this.get();
            history = history.filter(function(item) {
                return item.toLowerCase() !== keyword.toLowerCase();
            });
            history.unshift(keyword);

            if (history.length > this.maxItems) {
                history = history.slice(0, this.maxItems);
            }

            this.save(history);
        },

        remove: function(keyword) {
            let history = this.get();
            history = history.filter(function(item) {
                return item !== keyword;
            });
            this.save(history);
        },

        clear: function() {
            localStorage.removeItem(this.storageKey);
        }
    };

    // ==== XỬ LÝ INPUT ====
    searchInput.addEventListener("compositionstart", function() {
        isComposing = true;
    });

    searchInput.addEventListener("compositionend", function() {
        isComposing = false;
        triggerSuggest();
    });

    searchInput.addEventListener("input", function() {
        if (!isComposing) triggerSuggest();
    });

    searchInput.addEventListener("focus", function() {
        if (searchInput.value.trim() === "") {
            showSearchHistory();
        }
    });

    // ==== HIỂN THỊ LỊCH SỬ TÌM KIẾM ====
    function showSearchHistory() {
        const history = SearchHistory.get();

        if (history.length === 0) {
            suggestList.style.display = "none";
            return;
        }

        suggestList.innerHTML = "";

        const header = document.createElement("div");
        header.className = "suggest-header";
        header.innerHTML = '<span>Lịch sử tìm kiếm</span><span class="clear-history" onclick="clearAllHistory()">Xóa tất cả</span>';
        suggestList.appendChild(header);

        history.forEach(function(keyword) {
            const li = document.createElement("li");
            li.className = "list-group-item list-group-item-action history-item";
            li.innerHTML = '<span style="flex: 1;">' + escapeHtml(keyword) + '</span><i class="bi bi-x-lg delete-history-item" onclick="deleteHistoryItem(event, \'' + escapeHtml(keyword) + '\')"></i>';

            li.onclick = function(e) {
                if (!e.target.classList.contains('delete-history-item')) {
                    searchInput.value = keyword;
                    SearchHistory.add(keyword);
                    searchInput.form.submit();
                }
            };

            suggestList.appendChild(li);
        });

        suggestList.style.display = "block";
    }

    // ==== TÌM KIẾM VÀ GỢI Ý ====
    function triggerSuggest() {
        const keyword = searchInput.value.trim();

        if (keyword.length === 0) {
            showSearchHistory();
            return;
        }

        clearTimeout(debounceTimer);
        debounceTimer = setTimeout(function() {
            fetch(contextPath + "/search-suggestion?keyword=" + encodeURIComponent(keyword))
                .then(function(res) { return res.json(); })
                .then(function(data) {
                    displaySuggestions(data, keyword);
                })
                .catch(function(err) {
                    console.error('Lỗi khi tìm kiếm:', err);
                    suggestList.style.display = "none";
                });
        }, 300);
    }

    // ==== HIỂN THỊ GỢI Ý ====
    function displaySuggestions(data, keyword) {
        suggestList.innerHTML = "";

        const history = SearchHistory.get();
        const hasHistory = history.length > 0;
        const hasSuggestions = data && data.length > 0;

        if (!hasHistory && !hasSuggestions) {
            suggestList.innerHTML = '<div class="suggest-empty">Không tìm thấy kết quả</div>';
            suggestList.style.display = "block";
            return;
        }

        if (hasHistory) {
            const relatedHistory = history.filter(function(item) {
                return item.toLowerCase().includes(keyword.toLowerCase());
            });

            if (relatedHistory.length > 0) {
                const historyHeader = document.createElement("div");
                historyHeader.className = "suggest-header";
                historyHeader.innerHTML = '<span>Lịch sử tìm kiếm</span>';
                suggestList.appendChild(historyHeader);

                relatedHistory.slice(0, 3).forEach(function(item) {
                    const li = document.createElement("li");
                    li.className = "list-group-item list-group-item-action history-item";
                    li.innerHTML = '<span style="flex: 1;">' + highlightKeyword(item, keyword) + '</span><i class="bi bi-x-lg delete-history-item" onclick="deleteHistoryItem(event, \'' + escapeHtml(item) + '\')"></i>';

                    li.onclick = function(e) {
                        if (!e.target.classList.contains('delete-history-item')) {
                            searchInput.value = item;
                            SearchHistory.add(item);
                            searchInput.form.submit();
                        }
                    };

                    suggestList.appendChild(li);
                });

                if (hasSuggestions) {
                    const divider = document.createElement("div");
                    divider.className = "suggest-divider";
                    suggestList.appendChild(divider);
                }
            }
        }

        if (hasSuggestions) {
            if (hasHistory) {
                const suggestionHeader = document.createElement("div");
                suggestionHeader.className = "suggest-header";
                suggestionHeader.innerHTML = '<span>Gợi ý sản phẩm</span>';
                suggestList.appendChild(suggestionHeader);
            }

            data.forEach(function(item) {
                const li = document.createElement("li");
                li.className = "list-group-item list-group-item-action search-item";
                li.innerHTML = highlightKeyword(item.name, keyword);

                li.onclick = function() {
                    SearchHistory.add(item.name);
                    window.location.href = contextPath + "/product-detail?id=" + item.id;
                };

                suggestList.appendChild(li);
            });
        }

        suggestList.style.display = "block";
    }

    // ==== XÓA LỊCH SỬ ====
    function deleteHistoryItem(event, keyword) {
        event.stopPropagation();
        SearchHistory.remove(keyword);

        if (searchInput.value.trim() === "") {
            showSearchHistory();
        } else {
            triggerSuggest();
        }
    }

    function clearAllHistory() {
        if (confirm('Bạn có chắc muốn xóa toàn bộ lịch sử tìm kiếm?')) {
            SearchHistory.clear();
            showSearchHistory();
        }
    }

    // ==== LƯU LỊCH SỬ KHI SUBMIT ====
    searchInput.form.addEventListener('submit', function(e) {
        const keyword = searchInput.value.trim();
        if (keyword) {
            SearchHistory.add(keyword);
        }
    });

    // ==== ẨN SUGGEST KHI CLICK RA NGOÀI ====
    document.addEventListener("click", function(e) {
        if (!e.target.closest(".search-bar")) {
            suggestList.style.display = "none";
        }
    });

    // ==== UTILITY FUNCTIONS ====
    function highlightKeyword(text, keyword) {
        var escaped = keyword.split('').map(function(char) {
            if ('.*+?^\${}()|[]\\'.indexOf(char) !== -1) {
                return '\\' + char;
            }
            return char;
        }).join('');

        var regex = new RegExp("(" + escaped + ")", "gi");
        return text.replace(regex, "<strong>\$1</strong>");
    }

    function escapeHtml(text) {
        var div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
</script>


</body>

</html>