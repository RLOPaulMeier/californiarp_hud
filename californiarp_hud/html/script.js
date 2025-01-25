window.addEventListener('message', function(event) {
    if (event.data.action === 'updateHUD') {
        document.querySelector('.plz').innerText = `PLZ ${event.data.postal || "Unbekannt"}`;
        document.querySelector('.id').innerText = `ID ${event.data.id || ""}`;
        document.querySelector('.row:nth-child(2) span').innerText = `$${event.data.cash || 0}`;
        document.querySelector('.job').innerText = event.data.job || "Unemployed";

        const jobIcon = document.querySelector('.job-icon');
        jobIcon.style.backgroundImage = `url('icons/jobs/${event.data.jobIcon || "default"}.png')`;

        document.querySelector('.bar.hunger').style.width = `${event.data.hunger || 100}%`;
        document.querySelector('.bar.thirst').style.width = `${event.data.thirst || 100}%`;
    }

    if (event.data.action === 'updateTalkingStatus') {
        const firstRow = document.querySelector('.row:first-child');
        if (event.data.isTalking) {
            firstRow.classList.add('talking');
        } else {
            firstRow.classList.remove('talking');
        }
    }
});
