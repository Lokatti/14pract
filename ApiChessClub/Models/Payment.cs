using System;
using System.Collections.Generic;

namespace ApiChessClub.Models
{
    public partial class Payment
    {
        public int PaymentId { get; set; }
        public int GroupsId { get; set; }
        public int UsersId { get; set; }
        public DateTime? Creating { get; set; }

        public virtual Group Groups { get; set; } = null!;
        public virtual User Users { get; set; } = null!;
    }
}
