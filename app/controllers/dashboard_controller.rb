class DashboardController < AdminController
	
	def index
	end
	
	def teachers
		@teachers = Teacher.all
	end
	
	def students
		@students = Student.all
	end
end
