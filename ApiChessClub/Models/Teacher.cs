using System;
using System.Collections.Generic;

namespace ApiChessClub.Models
{
    public partial class Teacher
    {
        public int TeachersId { get; set; }
        public string FirstNameTeacher { get; set; } = null!;
        public string LastNameTeacher { get; set; } = null!;
        public string? MiddleNameTeacher { get; set; }
        public int Rating { get; set; }
        public int TeacherCategoryId { get; set; }
        public int? GroupsId { get; set; }

        public virtual Group? Groups { get; set; }
        public virtual TeacherCategory TeacherCategory { get; set; } = null!;
    }
}
