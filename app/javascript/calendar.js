import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';

document.addEventListener('DOMContentLoaded', function () {
  const calendarEl = document.getElementById('calendar');
  const careRecipientId = calendarEl.dataset.careRecipientId; // ✅ HTMLからIDを取得

  const calendar = new Calendar(calendarEl, {
    plugins: [dayGridPlugin],
    initialView: 'dayGridMonth',
    events: `/care_recipients/${careRecipientId}/visit_events`, // ✅ ここに記述
  });

  calendar.render();
});