
new Vue({
	el: "#login-div",
	data: {
		flag: false,
		user:{
			username:"",
			password:""
		}
	},
	methods: {
		login: function() {
			var _this =this;
			axios.post('/user/login',{
				userName:_this.user.username,
				password:_this.user.password
			}).then(function(res){
				confirm.log()
				console.dir(res.data)
				if(res.data.length===0){
					_this.flag=true;
				}else{
					_this.flag=false;
				}
			})
		}
	}
});
