$(document).ready(function () {

    // prepare bulletin for user clicks
    $('.challenge').each(function (el) {
        // display grade if exists
        if ($(this).data('grade') > 0) $(this).html($(this).html() + '<br><span class="grade">' + $(this).data('grade') + '</span>')
        // on click, prepare modal and show it
        $(this).click(function () {
            pin = $('#pin').val()
            $('#challengeid').val($(this).data('challengeid'))
            $('#questionid').val($(this).data('questionid'))
            $('#challengeText').html($(this).data('question'))
            $('#ModalChallenge').modal('show')
        })
    })

    // Put person id in input field when click on generate diploma
    $('button[name="diploma"]').click(function () {
        $('#pid').val($(this).data('pid'))
        inp = document.createElement('input');
        inp.name = 'diploma'
        document.getElementById('adminform').appendChild(inp)
        $('#adminform').submit()
    })

    // Remove message
    setTimeout(function () {
        $('#alert').fadeOut();
    }, 2000);
})

function idleLogout() { //Detect if any button/touchscreen/click is pressed, and call resetTimer
    var t;
    window.onload = resetTimer;
    window.onmousemove = resetTimer;
    window.onmousedown = resetTimer;      
    window.ontouchstart = resetTimer;
    window.onclick = resetTimer;
    window.onkeypress = resetTimer;   
    window.addEventListener('scroll', resetTimer, true);

    function logout() { //Redirect to the index.php page.
		window.location.href = 'index.php';
    }

    function resetTimer() { //Clear the timeout value and call the logout function after 60 seconds.
        clearTimeout(t);
        t = setTimeout(logout, 60000);  // time is in milliseconds
    }
}