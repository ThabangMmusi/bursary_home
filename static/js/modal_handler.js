function setupModal(modalId, overlayId, closeBtnId, cancelBtnId, confirmBtnId, dataMapping) {
    const modalOverlay = document.getElementById(overlayId);
    const modal = document.getElementById(modalId);
    const closeBtn = document.getElementById(closeBtnId);
    const cancelBtn = document.getElementById(cancelBtnId);
    const confirmBtn = document.getElementById(confirmBtnId);

    function showModal(data) {
        if (!modalOverlay || !modal) return;

        for (const key in dataMapping) {
            const element = document.getElementById(dataMapping[key]);
            if (element) {
                element.textContent = data[key] || 'N/A';
            }
        }

        modalOverlay.classList.add('active');
        modal.querySelector('button, a, input, select, textarea')?.focus();
    }

    function hideModal() {
        if (!modalOverlay) return;
        modalOverlay.classList.remove('active');
    }

    if (closeBtn) closeBtn.addEventListener('click', hideModal);
    if (cancelBtn) cancelBtn.addEventListener('click', hideModal);
    if (modalOverlay) {
        modalOverlay.addEventListener('click', function(e) {
            if (e.target === modalOverlay) {
                hideModal();
            }
        });
    }

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            if (modalOverlay?.classList.contains('active')) {
                hideModal();
            }
        }
    });

    return { showModal, hideModal, confirmBtn };
}

function setupSuccessDialog(overlayId, closeBtnId) {
    const successDialogOverlay = document.querySelector(overlayId);
    const successDialogCloseBtn = document.querySelector(closeBtnId);

    function showSuccessDialog() {
        if (successDialogOverlay) {
            successDialogOverlay.classList.add('active');
            setTimeout(() => {
                hideSuccessDialog();
            }, 3000);
        }
    }

    function hideSuccessDialog() {
        if (successDialogOverlay) {
            successDialogOverlay.classList.remove('active');
        }
    }

    if (successDialogCloseBtn) {
        successDialogCloseBtn.addEventListener('click', hideSuccessDialog);
    }

    return { showSuccessDialog, hideSuccessDialog };
}
