$(document).on('turbolinks:load', function () {
    $('.answers').on('click', '.edit-answer-link', function (e) {
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).toggle()
    })


    $('.vote-link').on('ajax:success', function(e) {
        var votable = e.detail[0];
        console.log(e)
        console.log(votable)
        console.log('#' + votable['type'] +  '-' + votable['id'] + ' .' + votable['type'] + '-score')
        $('#' + votable['type'] +  '-' + votable['id'] + ' .' + votable['type'] + '-score').html(votable['score']);
    })
        .on('ajax:error', function (e) {
        })

})
