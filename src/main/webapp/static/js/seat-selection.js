// Interactive Seat Selection Logic - VoyageBus Express

document.addEventListener('DOMContentLoaded', function () {
    var selectedSeats = [];
    var seatElements = document.querySelectorAll('.seat:not(.booked)');
    var scheduleFare = parseFloat(document.getElementById('scheduleFare') ? document.getElementById('scheduleFare').value : 0);
    var selectedListEl = document.getElementById('selectedSeatsDisplay');
    var totalFareEl = document.getElementById('totalFareDisplay');
    var proceedBtn = document.getElementById('proceedToCheckoutBtn');
    var seatsInput = document.getElementById('selectedSeatsInput');

    seatElements.forEach(function (seat) {
        seat.addEventListener('click', function () {
            var seatNumber = this.getAttribute('data-seat');
            var index = selectedSeats.indexOf(seatNumber);

            if (index > -1) {
                // Deselect
                selectedSeats.splice(index, 1);
                this.classList.remove('selected');
            } else {
                // Max 6 seats limit per booking for safety
                if (selectedSeats.length >= 6) {
                    alert('You can select a maximum of 6 seats per booking.');
                    return;
                }
                selectedSeats.push(seatNumber);
                this.classList.add('selected');
            }

            updateSummary();
        });
    });

    function updateSummary() {
        if (selectedListEl) {
            if (selectedSeats.length === 0) {
                selectedListEl.innerHTML = '<span style="color: #999;">No seats selected</span>';
            } else {
                var badges = selectedSeats.map(function (s) {
                    return '<span style="display:inline-block; background-color:#D62828; color:#fff; font-weight:600; padding:3px 8px; border-radius:4px; margin-right:4px; font-size:12px;">' + s + '</span>';
                }).join(' ');
                selectedListEl.innerHTML = badges;
            }
        }

        var total = selectedSeats.length * scheduleFare;
        if (totalFareEl) {
            totalFareEl.innerText = 'INR ' + total.toFixed(2);
        }

        if (seatsInput) {
            seatsInput.value = selectedSeats.join(',');
        }

        if (proceedBtn) {
            proceedBtn.disabled = selectedSeats.length === 0;
            if (selectedSeats.length === 0) {
                proceedBtn.style.opacity = '0.6';
                proceedBtn.style.cursor = 'not-allowed';
            } else {
                proceedBtn.style.opacity = '1';
                proceedBtn.style.cursor = 'pointer';
            }
        }
    }

    // Initialize summary
    updateSummary();
});
