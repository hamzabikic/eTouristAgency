using eTouristAgencyAPI.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace eTouristAgencyAPI.Controllers
{
    public abstract class CRUDController<TDbModel, TResponseModel, TSearchModel, TInsertModel, TUpdateModel> : BaseController<TDbModel, TResponseModel, TSearchModel>
    {
        private readonly ICRUDService<TDbModel, TResponseModel, TSearchModel, TInsertModel, TUpdateModel> _service;

        public CRUDController(ICRUDService<TDbModel, TResponseModel, TSearchModel, TInsertModel, TUpdateModel> crudService) : base(crudService)
        {
            _service = crudService;
        }

        [HttpPost]
        public virtual async Task<ActionResult> Add([FromBody] TInsertModel insertModel)
        {
            try
            {
                await _service.AddAsync(insertModel);
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPut("{id}")]
        public virtual async Task<ActionResult> Update(Guid id, [FromBody] TUpdateModel updateModel)
        {
            try
            {
                await _service.UpdateAsync(id, updateModel);
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
