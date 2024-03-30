using System;
using System.Collections.Generic;

namespace ApiChessClub.Models
{
    public partial class GroupType
    {

        public int GroupTypeId { get; set; }
        public string DescriptionType { get; set; } = null!;
        public string GroupTypeName { get; set; } = null!;

    }
}
