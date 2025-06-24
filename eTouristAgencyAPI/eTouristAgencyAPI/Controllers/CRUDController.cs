using eTouristAgencyAPI.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace eTouristAgencyAPI.Controllers
{
    public abstract class CRUDController<TDbModel, TResponseModel, TSearchModel, TInsertModel> : BaseController<TDbModel, TResponseModel, TSearchModel>
    {
        protected new readonly ICRUDService<TDbModel, TResponseModel, TSearchModel, TInsertModel> _service;

        public CRUDController(ICRUDService<TDbModel, TResponseModel, TSearchModel, TInsertModel> crudService) : base(crudService)
        {
            _service = crudService;
        }

        [HttpPost]
        public async Task<ActionResult<TResponseModel>> Add([FromBody] TInsertModel insertModel)
        {
            try
            {
                var id = await _service.AddAsync(insertModel);
                return Ok(id);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
