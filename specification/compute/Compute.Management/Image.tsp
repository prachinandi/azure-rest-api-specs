import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * The source user image virtual hard disk. The virtual hard disk will be copied before being attached to the virtual machine. If SourceImage is provided, the destination virtual hard drive must not exist.
 */
model Image is Azure.ResourceManager.TrackedResource<ImageProperties> {
  ...ResourceNameParameter<
    Resource = Image,
    KeyName = "imageName",
    SegmentName = "images",
    NamePattern = ""
  >;

  /**
   * The extended location of the Image.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property"
  extendedLocation?: ExtendedLocation;
}

@armResourceOperations
interface Images {
  /**
   * Gets an image.
   */
  get is ComputeResourceRead<
    Image,
    Parameters = {
      /**
       * The expand expression to apply on the operation.
       */
      @query("$expand")
      $expand?: string;
    }
  >;

  /**
   * Create or update an image.
   */
  createOrUpdate is ComputeResourceCreateOrReplaceAsync<
    Image,
    LroHeaders = ArmLroLocationHeader & Azure.Core.Foundations.RetryAfterHeader
  >;

  /**
   * Update an image.
   */
  @patch(#{ implicitOptionality: false })
  update is ComputeCustomPatchAsync<
    Image,
    ImageUpdate,
    Response = ArmResponse<Image> | ArmResourceCreatedResponse<
      Image,
      LroHeaders = ArmLroLocationHeader &
        Azure.Core.Foundations.RetryAfterHeader
    >
  >;

  /**
   * Deletes an Image.
   */
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ComputeResourceDeleteAsync<Image>;

  /**
   * Gets the list of images under a resource group. Use nextLink property in the response to get the next page of Images. Do this till nextLink is null to fetch all the Images.
   */
  listByResourceGroup is ComputeResourceListByParent<
    Image,
    Response = ImageListResult
  >;

  /**
   * Gets the list of Images in the subscription. Use nextLink property in the response to get the next page of Images. Do this till nextLink is null to fetch all the Images.
   */
  list is ComputeListBySubscription<Image, Response = ImageListResult>;
}

@@doc(Image.name, "The name of the image.");
@@doc(Image.properties, "Describes the properties of an Image.");
@@doc(Images.createOrUpdate::parameters.resource,
  "Parameters supplied to the Create Image operation."
);
@@doc(Images.update::parameters.properties,
  "Parameters supplied to the Update Image operation."
);
