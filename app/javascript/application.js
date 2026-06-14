// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

document.addEventListener("DOMContentLoaded", () => {
  const modal = document.getElementById("photo-modal");
  const modalImg = document.getElementById("photo-modal-img");
  const closeBtn = document.getElementById("photo-modal-close");

  document.querySelectorAll(".zoomable-photo").forEach(img => {
    img.addEventListener("click", () => {
      modal.style.display = "block";
      modalImg.src = img.dataset.full;
    });
  });

  closeBtn.addEventListener("click", () => {
    modal.style.display = "none";
  });

  modal.addEventListener("click", () => {
    modal.style.display = "none";
  });
});

document.addEventListener("DOMContentLoaded", () => {
  const dropArea = document.getElementById("photo-drop-area");
  const fileInput = document.getElementById("photo-input");
  const selectBtn = document.getElementById("photo-select-btn");
  const preview = document.getElementById("photo-preview");

  if (!dropArea) return;

  // 通常のファイル選択
  selectBtn.addEventListener("click", () => fileInput.click());

  fileInput.addEventListener("change", () => {
    showPreview(fileInput.files[0]);
  });

  // D&D イベント
  dropArea.addEventListener("dragover", (e) => {
    e.preventDefault();
    dropArea.classList.add("dragover");
  });

  dropArea.addEventListener("dragleave", () => {
    dropArea.classList.remove("dragover");
  });

  dropArea.addEventListener("drop", (e) => {
    e.preventDefault();
    dropArea.classList.remove("dragover");

    const file = e.dataTransfer.files[0];
    fileInput.files = e.dataTransfer.files; // ← form にセットされる
    showPreview(file);
  });

  // プレビュー表示
  function showPreview(file) {
    if (!file) return;

    const reader = new FileReader();
    reader.onload = (e) => {
      preview.innerHTML = `<img src="${e.target.result}" class="care-photo">`;
    };
    reader.readAsDataURL(file);
  }
});

