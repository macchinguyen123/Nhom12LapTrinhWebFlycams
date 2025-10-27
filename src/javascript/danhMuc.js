const slider = document.querySelector('.slider');
const slides = document.querySelectorAll('.slide');
const dotsContainer = document.querySelector('.dots');
let currentIndex = 0;
let autoSlide;

// Tạo dots
function createDots() {
    slides.forEach((_, i) => {
        const dot = document.createElement('div');
        dot.classList.add('dot');
        if (i === 0) dot.classList.add('active');
        dot.addEventListener('click', () => goToSlide(i));
        dotsContainer.appendChild(dot);
    });
}

function updateDots() {
    document.querySelectorAll('.dot').forEach((dot, i) => {
        dot.classList.toggle('active', i === currentIndex);
    });
}

function goToSlide(i) {
    currentIndex = (i + slides.length) % slides.length;
    slider.style.transform = `translateX(-${currentIndex * 100}%)`;
    updateDots();
}

// Mũi tên chuyển ảnh
document.querySelector('.arrow.left').addEventListener('click', () => {
    goToSlide(currentIndex - 1);
});
document.querySelector('.arrow.right').addEventListener('click', () => {
    goToSlide(currentIndex + 1);
});

// Auto slide
function startSlide() {
    autoSlide = setInterval(() => {
        goToSlide(currentIndex + 1);
    }, 3000);
}
function stopSlide() {
    clearInterval(autoSlide);
}

document.querySelector('.banner-right').addEventListener('mouseenter', stopSlide);
document.querySelector('.banner-right').addEventListener('mouseleave', startSlide);

createDots();
startSlide();
