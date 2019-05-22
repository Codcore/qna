$(document).on('turbolinks:load', function () {
    $('.answers').on('click', '.edit-answer-link', function (e) {
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).toggle()
    })

    voteLinksAjaxHandler()

    App.cable.subscriptions.create('AnswersChannel', {
        connected() {
            return this.perform('follow', { question_id: gon.question_id });
        }
        ,

        received(data) {
            console.log(data);
            console.log(JST["answer"](data));
            if (data.answer.author_id != gon.user_id) {
              $(".answers").append(JST["answer"](data));
              voteLinksAjaxHandler()
            }
        }
    })
})

var voteLinksAjaxHandler = function () {
    $('.vote-link').on('ajax:success', function(e) {
        var votable = e.detail[0];
        console.log(votable)
        console.log('#' + votable['type'] +  '-' + votable['id'] + ' .' + votable['type'] + '-score')
        $('#' + votable['type'] +  '-' + votable['id'] + ' .' + votable['type'] + '-score').html(votable['score']);
    })
        .on('ajax:error', function (e) {
        })
}
