using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ApiChessClub.Models;

namespace ApiChessClub.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserTournamentsController : ControllerBase
    {
        private readonly ChessClubContext _context;

        public UserTournamentsController(ChessClubContext context)
        {
            _context = context;
        }

        // GET: api/UserTournaments
        [HttpGet]
        public async Task<ActionResult<IEnumerable<UserTournament>>> GetUserTournaments()
        {
          if (_context.UserTournaments == null)
          {
              return NotFound();
          }
            return await _context.UserTournaments.ToListAsync();
        }

        // GET: api/UserTournaments/5
        [HttpGet("{id}")]
        public async Task<ActionResult<UserTournament>> GetUserTournament(int id)
        {
          if (_context.UserTournaments == null)
          {
              return NotFound();
          }
            var userTournament = await _context.UserTournaments.FindAsync(id);

            if (userTournament == null)
            {
                return NotFound();
            }

            return userTournament;
        }

        // PUT: api/UserTournaments/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutUserTournament(int id, UserTournament userTournament)
        {
            if (id != userTournament.UserTournamentsId)
            {
                return BadRequest();
            }

            _context.Entry(userTournament).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!UserTournamentExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/UserTournaments
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<UserTournament>> PostUserTournament(UserTournament userTournament)
        {
          if (_context.UserTournaments == null)
          {
              return Problem("Entity set 'ChessClubContext.UserTournaments'  is null.");
          }
            _context.UserTournaments.Add(userTournament);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetUserTournament", new { id = userTournament.UserTournamentsId }, userTournament);
        }

        // DELETE: api/UserTournaments/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUserTournament(int id)
        {
            if (_context.UserTournaments == null)
            {
                return NotFound();
            }
            var userTournament = await _context.UserTournaments.FindAsync(id);
            if (userTournament == null)
            {
                return NotFound();
            }

            _context.UserTournaments.Remove(userTournament);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool UserTournamentExists(int id)
        {
            return (_context.UserTournaments?.Any(e => e.UserTournamentsId == id)).GetValueOrDefault();
        }
    }
}
