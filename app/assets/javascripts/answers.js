$(document).on('turbolinks:load', function () {
    $('.answers').on('click', '.edit-answer-link', function (e) {
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).toggle()
    })

    $('.answers').on('click', '.commentary-button', function (e) {
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('form#commentary-for-answer-' + answerId).toggle()
    })

    $('.question .commentaries').on('click', '.commentary-button', function(e) {
        var questionId;
        e.preventDefault();
        $(this).hide();
        questionId = $(this).data('questionId');
        console.log(questionId);
        $('form#commentary-for-question-' + questionId).toggle();
    });


    voteLinksAjaxHandler()

    App.cable.subscriptions.create('AnswersChannel', {
        connected() {
            return this.perform('follow', { question_id: gon.question_id });
        }
        ,

        received(data) {
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
        $('#' + votable['type'] +  '-' + votable['id'] + ' .' + votable['type'] + '-score').html(votable['score']);
    })
        .on('ajax:error', function (e) {
        })
}
