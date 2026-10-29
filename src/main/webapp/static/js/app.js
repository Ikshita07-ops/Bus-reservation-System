// VoyageBus Express - Main Application JavaScript

document.addEventListener('DOMContentLoaded', function () {
    // 1. Enforce minimum date for journey date input (Today)
    var dateInputs = document.querySelectorAll('input[type="date"]');
    var today = new Date().toISOString().split('T')[0];
    dateInputs.forEach(function (input) {
        if (!input.getAttribute('min')) {
            input.setAttribute('min', today);
        }
    });

    // 2. Alert Dismissal
    var alertCloseButtons = document.querySelectorAll('.alert-close');
    alertCloseButtons.forEach(function (btn) {
        btn.addEventListener('click', function () {
            var alert = this.closest('.alert');
            if (alert) {
                alert.style.opacity = '0';
                setTimeout(function () {
                    alert.remove();
                }, 200);
            }
        });
    });

    // 3. Quick route selection helper
    window.selectQuickRoute = function(source, destination) {
        var srcInput = document.getElementById('searchSource');
        var dstInput = document.getElementById('searchDestination');
        if (srcInput && dstInput) {
            srcInput.value = source;
            dstInput.value = destination;
            var form = srcInput.closest('form');
            if (form) {
                form.submit();
            }
        } else {
            window.location.href = window.location.pathname.replace(/\/+$/, '') + '/search?source=' + encodeURIComponent(source) + '&destination=' + encodeURIComponent(destination);
        }
    };
});
