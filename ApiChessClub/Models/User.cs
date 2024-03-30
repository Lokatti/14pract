using System;
using System.Collections.Generic;

namespace ApiChessClub.Models
{
    public partial class User
    {

        public int UsersId { get; set; }
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string? MiddleName { get; set; }
        public int? Rating { get; set; }
        public string Role { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string Password { get; set; } = null!;
        public string? FcmToken { get; set; }
        public string? Salt { get; set; }
        public int? RequisitesId { get; set; }
        public int? PictureId { get; set; }

        public virtual Picture? Picture { get; set; }
        public virtual Requisite? Requisites { get; set; }
     }
}
