Vue.component('comment-form', {
    template: '#comment-form', 
    data: function () {
          return {
              email : "", 
              emailBlured : false,
              valid : false, 
              submitted : false
          }
      },
    methods : {
      validate : function(){
        this.emailBlured = true;
         if( this.validEmail(this.email)){
            this.valid = true;
         }
      },
      validEmail : function(email) {
          var re = /(.+)@(.+){2,}\.(.+){2,}/;
          return re.test(email.toLowerCase());
      },
      submit : function(){                   
          this.validate();     
          if(this.valid){
            //THIS IS WHERE YOU SUBMIT DATA TO SERVER
            this.submitted = true;
          }
        } //end submit
    }
  })
  
  new Vue({
    el: '#app'
  })