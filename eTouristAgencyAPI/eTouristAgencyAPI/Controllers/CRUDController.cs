using eTouristAgencyAPI.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace eTouristAgencyAPI.Controllers
{
    public abstract class CRUDController<TDbModel, TResponseModel, TSearchModel, TInsertModel, TUpdateModel> : BaseController<TDbModel, TResponseModel, TSearchModel>
    {
        protected new readonly ICRUDService<TDbModel, TResponseModel, TSearchModel, TInsertModel, TUpdateModel> _service;

        public CRUDController(ICRUDService<TDbModel, TResponseModel, TSearchModel, TInsertModel, TUpdateModel> crudService) : base(crudService)
        {
            _service = crudService;
        }

        [HttpPost]
        public async Task<ActionResult<TResponseModel>> Add([FromBody] TInsertModel insertModel)
        {
            try
            {
                var responseModel = await _service.AddAsync(insertModel);
                return Ok(responseModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<TResponseModel>> Update(Guid id, [FromBody] TUpdateModel updateModel)
        {
            try
            {
                var responseModel = await _service.UpdateAsync(id, updateModel);
                return Ok(responseModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
