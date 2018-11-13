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

    // Print pin code
    $('.pinbox').click(function () {
        w = window.open('/pages/pinlabel.html', '_blank')
        let pb = $(this)

        // ugly but I didn't find a way to wait properly for the w's DOM to load
        setTimeout(function () {
            w.document.getElementById('pin').innerHTML = pb.html()
            w.print()
            w.close()
        }, 500)
    })
})