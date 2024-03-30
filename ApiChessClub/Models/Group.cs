using System;
using System.Collections.Generic;

namespace ApiChessClub.Models
{
    public partial class Group
    {

        public int GroupsId { get; set; }
        public string GroupsName { get; set; } = null!;
        public string Description { get; set; } = null!;
        public decimal Price { get; set; }
        public int UsersId { get; set; }
        public int GroupTypeId { get; set; }

        public virtual GroupType GroupType { get; set; } = null!;
        public virtual User Users { get; set; } = null!;
    }
}
